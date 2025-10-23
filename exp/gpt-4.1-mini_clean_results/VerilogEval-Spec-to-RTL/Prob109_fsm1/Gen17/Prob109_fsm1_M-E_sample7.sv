module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // One-hot encoding: stateA and stateB
    reg stateA, stateB;
    wire nextA, nextB;

    // Next-state combinational logic
    // From the diagram:
    // B (stateB=1) on 0 -> A
    // B (stateB=1) on 1 -> B
    // A (stateA=1) on 0 -> B
    // A (stateA=1) on 1 -> A

    assign nextA = (stateB & ~in) | (stateA & in);
    assign nextB = (stateB & in) | (stateA & ~in);

    // Sequential state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            stateA <= 1'b0;
            stateB <= 1'b1;  // Reset to state B
        end else begin
            stateA <= nextA;
            stateB <= nextB;
        end
    end

    // Moore output depends solely on current state; output=1 in state B
    assign out = stateB;

endmodule