module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Next-state combinational logic using assign statements
    wire in0 = ~in;
    wire in1 = in;

    assign next_state = 
        (state == A) ? (in0 ? A : B) :
        (state == B) ? (in0 ? C : B) :
        (state == C) ? (in0 ? A : D) :
        (state == D) ? (in0 ? C : B) :
        A; // Default state

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output asserted only in state D (Moore output)
    assign out = state[3];

endmodule