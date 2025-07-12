module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [1:0] cnt;
reg [3:0] data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        data <= d;
    end else if (cnt == 3) begin
        cnt <= 0;
        data <= d;
    end else begin
        cnt <= cnt + 1;
    end
end

always @(posedge clk) begin
    case (cnt)
        0: begin
            valid_out <= 1;
            dout <= data[3];
        end
        1: begin
            valid_out <= 0;
            dout <= data[2];
        end
        2: begin
            valid_out <= 0;
            dout <= data[1];
        end
        3: begin
            valid_out <= 0;
            dout <= data[0];
        end
    endcase
end

endmodule