module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [8:0] shift_reg; // 9-bit shift register with flag
reg [7:0] dout_parallel_reg;
reg dout_valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_reg <= 9'b100000000; // Initialize with flag set
        dout_parallel_reg <= 8'b00000000;
        dout_valid_reg <= 1'b0;
    end else begin
        if (din_valid) begin
            shift_reg <= {shift_reg[7:0], din_serial}; // Shift in serial data
            if (shift_reg[8]) begin // Flag indicates complete 8-bit word
                dout_parallel_reg <= shift_reg[7:0]; // Update parallel output
                dout_valid_reg <= 1'b1; // Set valid flag
            end else begin
                dout_valid_reg <= 1'b0; // Clear valid flag
            end
        end else begin
            shift_reg <= shift_reg; // Hold shift register if no valid data
            dout_valid_reg <= 1'b0; // Clear valid flag
        end
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule