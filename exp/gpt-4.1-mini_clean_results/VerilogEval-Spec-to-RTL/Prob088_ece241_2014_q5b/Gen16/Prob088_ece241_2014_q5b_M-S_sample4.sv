module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg state_A;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;  // reset to state A
        z <= 1'b0;        // output at reset per state A and x=0
    end else begin
        // Next state logic
        state_A <= state_A ? ~x : 1'b0;  // from A: next A if x=0; else B (0). From B: stay B (0)
        // Output logic (Mealy)
        z <= state_A ? x : ~x;
    end
end

endmodule