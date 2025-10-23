module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // State encoding
    // 0: A, 1: B
    reg state;

    // Asynchronous active-high reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // state A
        else if (state == 1'b0 && x)
            state <= 1'b1; // move from A to B
        else
            state <= state; // stay in B or A if x=0 at A
    end

    // Output logic (Mealy)
    assign z = (state == 1'b0) ? x : ~x;

endmodule