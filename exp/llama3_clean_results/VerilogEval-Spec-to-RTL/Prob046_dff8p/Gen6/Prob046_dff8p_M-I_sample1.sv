module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

always @(negedge clk) begin
    if(reset) begin
        // Directly reset to the specific value 0x34 (52 in decimal)
        q_reg <= 8'd52;
    end else begin
        // Otherwise, assign the input value
        q_reg <= d;
    end
end

// Assign the internal register to the output
assign q = q_reg;

endmodule