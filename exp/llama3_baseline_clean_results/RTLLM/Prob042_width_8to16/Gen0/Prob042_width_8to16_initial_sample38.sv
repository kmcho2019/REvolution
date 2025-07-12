module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock;
reg [7:0] data_in_reg;
reg flag;
reg [15:0] data_out_reg;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 0;
        data_in_reg <= 0;
        flag <= 0;
        data_out_reg <= 0;
        valid_out_reg <= 0;
    end else begin
        if (valid_in && !flag) begin
            // Store the first valid 8-bit input data
            data_lock <= data_in;
            flag <= 1;
        end else if (valid_in && flag) begin
            // Store the second valid 8-bit input data and concatenate
            data_in_reg <= data_in;
            data_out_reg <= {data_lock, data_in_reg};
            valid_out_reg <= 1;
            flag <= 0;
        end else begin
            valid_out_reg <= 0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule