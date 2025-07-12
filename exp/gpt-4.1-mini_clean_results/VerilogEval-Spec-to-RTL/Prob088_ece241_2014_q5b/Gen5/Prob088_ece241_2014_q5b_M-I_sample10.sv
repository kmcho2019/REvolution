module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic (simplified)
    // From A: next_state = x ? B : A
    // From B: next_state = B (remains)
    always @(*) begin
        next_state = (state == A) ? (x ? B : A) : B;
    end

    // Output logic as continuous assignment (Mealy output)
    // z = 1 when (state==A & x==1) or (state==B & x==0)
    assign z = (state == A) ? x : ~x;

endmodule