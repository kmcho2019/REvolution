module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state;
    wire [1:0] next_state;

    // Combinational next-state logic with continuous assignments
    // Encode each next state bit as a combinational expression from current state and input

    // next_state[1] logic:
    // A=00 -> next= A(00) or B(01)
    // B=01 -> next= C(10) or B(01)
    // C=10 -> next= A(00) or D(11)
    // D=11 -> next= C(10) or B(01)
    // Explicitly writing bit1 of next_state for each case:
    // State A: in=0 -> A=00 (bit1=0), in=1 -> B=01 (bit1=0)
    // State B: in=0 -> C=10 (bit1=1), in=1 -> B=01 (bit1=0)
    // State C: in=0 -> A=00 (bit1=0), in=1 -> D=11 (bit1=1)
    // State D: in=0 -> C=10 (bit1=1), in=1 -> B=01 (bit1=0)
    assign next_state[1] =
        (~state[1] & ~state[0] & 1'b0) |   // A, in=0 -> 0
        (~state[1] & ~state[0] & in & 1'b0) | // A, in=1 -> 0
        (~state[1] & state[0] & ~in) |        // B, in=0 -> 1
        (~state[1] & state[0] & in & 1'b0) | // B, in=1 -> 0
        (state[1] & ~state[0] & in) |        // C, in=1 -> 1
        (state[1] & state[0] & ~in);          // D, in=0 -> 1

    // next_state[0] logic:
    // Similarly for bit0:
    // A: in=0 -> A(00) bit0=0, in=1 -> B(01) bit0=1
    // B: in=0 -> C(10) bit0=0, in=1 -> B(01) bit0=1
    // C: in=0 -> A(00) bit0=0, in=1 -> D(11) bit0=1
    // D: in=0 -> C(10) bit0=0, in=1 -> B(01) bit0=1
    assign next_state[0] =
        (~state[1] & ~state[0] & in) |       // A, in=1 -> 1
        (~state[1] & state[0] & in) |        // B, in=1 -> 1
        (state[1] & ~state[0] & in) |        // C, in=1 -> 1
        (state[1] & state[0] & in);           // D, in=1 -> 1

    // Actually the above is complicated. We can write simpler expressions by inspection:
    // next_state[1] = (state == B & in==0) | (state == C & in==1) | (state == D & in==0)
    // next_state[0] = (state == A & in==1) | (state == B & in==1) | (state == C & in==1) | (state == D & in==1)
    // Let's implement those:

    // Reassign next_state with cleaned expressions:
    wire next_state1 = ((state == B) && (in == 1'b0)) || ((state == C) && (in == 1'b1)) || ((state == D) && (in == 1'b0));
    wire next_state0 = (in == 1'b1) && ((state == A) || (state == B) || (state == C) || (state == D));

    assign next_state = {next_state1, next_state0};

    // Sequential logic: state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output logic: output=1 only in state D
    always @(*) begin
        case (state)
            D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule