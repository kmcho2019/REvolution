module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // Binary encoding for states (1-bit)
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic: From A, go to B if x=1, else stay; from B, stay in B
    always @(*) begin
        next_state = (state == A) ? (x ? B : A) : B;
    end

    // Mealy output: output depends on current state and input
    always @(*) begin
        // z = 1 if (state==A && x==1) or (state==B && x==0)
        z = (state == A) ? x : ~x;
    end

endmodule