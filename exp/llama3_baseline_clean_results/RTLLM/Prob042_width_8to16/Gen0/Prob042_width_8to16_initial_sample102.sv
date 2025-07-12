module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;
reg [7:0] data_in_reg;
reg flag_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'b0;
        data_in_reg <= 8'b0;
        flag_reg <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        if (valid_in) begin
            if (!flag_reg) begin
                data_lock <= data_in;
                flag_reg <= 1'b1;
            end else begin
                data_in_reg <= data_in;
                data_out <= {data_lock, data_in_reg};
                valid_out <= 1'b1;
                flag_reg <= 1'b0;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule