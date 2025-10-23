module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] counter;
reg [23:0] msg_bytes;

always @(posedge clk) begin
    if (reset) begin
        counter <= 2'b00;
        msg_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        if (in[3] == 1'b1) begin
            case (counter)
                2'b00: begin
                    msg_bytes[23:16] <= in;
                    counter <= 2'b01;
                end
                2'b01: begin
                    msg_bytes[15:8] <= in;
                    counter <= 2'b10;
                end
                2'b10: begin
                    msg_bytes[7:0] <= in;
                    counter <= 2'b00;
                    done <= 1'b1;
                end
            endcase
        end else begin
            counter <= counter;
            done <= 1'b0;
        end
    end
end

assign out_bytes = msg_bytes;

endmodule