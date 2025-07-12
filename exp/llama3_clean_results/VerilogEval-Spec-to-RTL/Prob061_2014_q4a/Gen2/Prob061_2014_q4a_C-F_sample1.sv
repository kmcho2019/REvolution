module TopModule(
    input clk,  // Clock signal
    input w,    // Input from the previous stage
    input R,    // Value to load
    input E,    // Enable shift
    input L,    // Load signal
    output Q    // Output of the module
);

reg q_reg;  // Register to store the current value

always @(posedge clk) begin
    case ({L, E})
        2'b10: q_reg <= R;  // Load has priority
        2'b01: q_reg <= w;  // Shift if load is not asserted
        default: ;         // Implicitly retain the current value
    endcase
end

assign Q = q_reg;  // Continuous assignment to output the current value

endmodule