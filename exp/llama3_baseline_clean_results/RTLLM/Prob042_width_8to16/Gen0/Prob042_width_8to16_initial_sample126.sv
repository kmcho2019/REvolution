module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock;
reg [7:0] data_in_reg;
reg valid_out_reg;
reg [15:0] data_out_reg;
reg flag;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'b0;
        data_in_reg <= 8'b0;
        valid_out_reg <= 1'b0;
        data_out_reg <= 16'b0;
        flag <= 1'b0;
    end else begin
        if (valid_in && !flag) begin
            // Store the first valid data
            data_lock <= data_in;
            flag <= 1'b1;
        end else if (valid_in && flag) begin
            // Store the second valid data and concatenate
            data_in_reg <= data_in;
            data_out_reg <= {data_lock, data_in_reg};
            valid_out_reg <= 1'b1;
            flag <= 1'b0;
        end else if (!valid_in && flag) begin
            // Do nothing, wait for the second valid data
        end else begin
            // Reset the output
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule