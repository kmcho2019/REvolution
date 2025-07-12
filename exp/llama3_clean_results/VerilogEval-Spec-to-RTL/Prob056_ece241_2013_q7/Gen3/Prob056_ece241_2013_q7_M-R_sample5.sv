module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

initial Q = 0; // Initialize Q to 0 at the start of the simulation

always @(posedge clk) begin
    case ({j, k})
        2'b00: Q <= Q; // Q remains the same
        2'b01: Q <= 1'b0; // Reset Q to 0
        2'b10: Q <= 1'b1; // Set Q to 1
        2'b11: Q <= ~Q; // Toggle Q
        default: Q <= Q; // Default case, should not occur
    endcase
end

endmodule