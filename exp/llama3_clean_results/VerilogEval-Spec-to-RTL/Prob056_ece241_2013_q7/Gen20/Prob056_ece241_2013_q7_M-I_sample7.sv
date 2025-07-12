module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 1'b0 // Initialize Q to 0 for a known initial state
);

always @(posedge clk) begin
    // Simplify the conditional logic for potential synthesis benefits
    case ({j, k})
        2'b00: Q <= Q; // No change
        2'b01: Q <= 1'b0;
        2'b10: Q <= 1'b1;
        2'b11: Q <= ~Q; // Toggle Q
    endcase
end

endmodule