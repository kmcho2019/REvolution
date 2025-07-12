module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;
    reg [3:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                data_reg <= d;
                cnt <= 2'b0;
                valid_out <= 1'b1;
            end else begin
                cnt <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
            dout <= data_reg[3];
            data_reg <= {data_reg[2:0], 1'b0};  // Shift left
        end
    end

endmodule