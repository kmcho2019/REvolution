module TopModule (
    input  wire clk,  // Positive edge clock
    input  wire ar,   // Asynchronous reset (active high)
    input  wire d,    // Data input
    output wire q     // Data output
);

reg q_reg;
assign q = q_reg;

// Positive edge-triggered DFF with async reset
// Note: For power optimization in larger designs, 
// consider clock gating when flip-flop isn't active
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q_reg <= 1'b0;  // Async reset has highest priority
    end else begin
        q_reg <= d;      // Normal data capture on clock edge
    end
end

endmodule