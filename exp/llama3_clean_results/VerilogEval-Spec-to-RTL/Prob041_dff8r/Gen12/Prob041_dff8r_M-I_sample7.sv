// Improved module with optimized reset and potential for low-power techniques
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Initialize the output to zero
logic [7:0] shift_reg = 8'b0;

always_ff @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
    end else begin
        shift_reg <= d;
    end
end

assign q = shift_reg;

endmodule