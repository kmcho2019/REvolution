module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock;
reg valid_lock;
reg [15:0] data_out_reg;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'b0;
        valid_lock <= 1'b0;
        data_out_reg <= 16'b0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            if (!valid_lock) begin
                // Store the first valid data
                data_lock <= data_in;
                valid_lock <= 1'b1;
            end else begin
                // Concatenate the stored data with the new data
                data_out_reg <= {data_lock, data_in};
                valid_out_reg <= 1'b1;
                valid_lock <= 1'b0;
            end
        end else if (valid_out_reg) begin
            // Reset the output registers after one clock cycle
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule