module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // One-hot encoded states
    localparam A = 2'b01;
    localparam B = 2'b10;

    reg [1:0] state, next_state;

    // Asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        // From A: go to B if x=1, else stay in A; From B: stay in B
        next_state = (state == A) ? (x ? B : A) : B;
    end

    // Mealy output logic
    always @(*) begin
        // z = 1 if (state==A && x==1) or (state==B && x==0)
        z = (state == A) ? x : ~x;
    end

endmodule