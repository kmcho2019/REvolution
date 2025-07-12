module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 1'b0 // Initialize Q to a default state
);

always @(posedge clk) begin
    case ({j, k})
        2'b00: Q <= Q; // Hold Q when j=0 and k=0
        2'b01: Q <= 1'b0; // Reset Q when j=0 and k=1
        2'b10: Q <= 1'b1; // Set Q when j=1 and k=0
        2'b11: Q <= ~Q; // Toggle Q when j=1 and k=1
    endcase
end

endmodule