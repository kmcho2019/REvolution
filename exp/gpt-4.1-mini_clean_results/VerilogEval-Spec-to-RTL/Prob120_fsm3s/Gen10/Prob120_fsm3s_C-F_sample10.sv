module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding using localparams
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state;

    wire next_state1, next_state0;
    wire [1:0] next_state;

    // Next state logic simplified from the state transition table:
    // next_state[1] = (state == B && in == 0) || (state == C && in == 1) || (state == D && in == 0)
    assign next_state1 = 
        ((state == B) && (in == 1'b0)) ||
        ((state == C) && (in == 1'b1)) ||
        ((state == D) && (in == 1'b0));

    // next_state[0] = (state == A && in == 1) || (state == B && in == 1) || (state == C && in == 1) || (state == D && in == 1)
    assign next_state0 =
        (in == 1'b1) && ((state == A) || (state == B) || (state == C) || (state == D));

    assign next_state = {next_state1, next_state0};

    // Sequential state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output is 1 only when in state D; combinational continuous assignment
    assign out = (state == D);

endmodule