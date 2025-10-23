module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

// Initialize Q to 0 at the start of the simulation
initial Q = 0;

// Define the LUT for the JK flip-flop
always @(posedge clk) begin
    case ({j, k, Q})
        3'b000: Q <= Q; // Qold
        3'b001: Q <= 0; // Reset
        3'b010: Q <= 1; // Set
        3'b011: Q <= ~Q; // Toggle
        3'b100: Q <= Q; // Qold
        3'b101: Q <= 0; // Reset
        3'b110: Q <= 1; // Set
        3'b111: Q <= ~Q; // Toggle
        default: Q <= Q; // Default to Qold for any other combination
    endcase
end

endmodule