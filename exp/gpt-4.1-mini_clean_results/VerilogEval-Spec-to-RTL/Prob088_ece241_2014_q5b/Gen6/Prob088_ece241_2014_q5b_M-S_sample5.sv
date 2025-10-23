module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);
    // One-hot encoded states: A=2'b01, B=2'b10
    reg [1:0] state;

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;    // Reset to state A
        else begin
            // Next state logic
            if (state[0])       // state A
                state <= x ? 2'b10 : 2'b01;
            else                // state B
                state <= 2'b10;  // stay in B
        end
    end

    // Output logic (Mealy)
    always @(*) begin
        // z = 1 when (in A and x=1) or (in B and x=0)
        z = (state[0] & x) | (state[1] & ~x);
    end
endmodule