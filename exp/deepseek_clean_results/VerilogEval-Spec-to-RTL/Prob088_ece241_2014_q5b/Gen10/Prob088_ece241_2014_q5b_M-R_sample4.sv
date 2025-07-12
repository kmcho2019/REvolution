module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg [1:0] state;  // one-hot encoding: state[0]=A, state[1]=B

    // Next state logic (A=state[0], B=state[1])
    wire [1:0] next_state = areset ? 2'b01 :  // reset to A
                           {state[0] & x | state[1],  // next B
                            state[0] & ~x};  // next A

    // Output logic (Mealy)
    assign z = state[0] ? x : ~x;

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule