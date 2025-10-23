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

    // Next state combinational logic using minimized boolean expressions:
    // next_state[1] = (state == B && in == 0) || (state == C && in == 1) || (state == D && in == 0)
    // next_state[0] = in & (state == A || state == B || state == C || state == D)
    wire next_state1 = ((state == B) && (~in)) | ((state == C) && in) | ((state == D) && (~in));
    wire next_state0 = in & ((state == A) | (state == B) | (state == C) | (state == D));
    wire [1:0] next_state = {next_state1, next_state0};

    // Sequential logic with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output: asserted only in state D
    assign out = (state == D);

endmodule