module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // State encoding parameters (one-hot)
    parameter S     = 10'b0000000001;
    parameter S1    = 10'b0000000010;
    parameter S11   = 10'b0000000100;
    parameter S110  = 10'b0000001000;
    parameter B0    = 10'b0000010000;
    parameter B1    = 10'b0000100000;
    parameter B2    = 10'b0001000000;
    parameter B3    = 10'b0010000000;
    parameter Count = 10'b0100000000;
    parameter Wait  = 10'b1000000000;

    // Next state logic using case statement
    reg [9:0] next_state;
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[0]:   // S
                next_state = d ? S1 : S;
            state[1]:   // S1
                next_state = d ? S11 : S;
            state[2]:   // S11
                next_state = d ? S11 : S110;
            state[3]:   // S110
                next_state = d ? B0 : S;
            state[4]:   // B0
                next_state = B1;
            state[5]:   // B1
                next_state = B2;
            state[6]:   // B2
                next_state = B3;
            state[7]:   // B3
                next_state = Count;
            state[8]:   // Count
                next_state = done_counting ? Wait : Count;
            state[9]:   // Wait
                next_state = ack ? S : Wait;
            default:
                next_state = S;
        endcase
    end

    // Next state outputs (individual bits)
    assign S_next     = next_state[0];
    assign S1_next    = next_state[1];
    assign B3_next    = next_state[7];
    assign Count_next = next_state[8];
    assign Wait_next  = next_state[9];

    // Output logic (Moore machine)
    assign shift_ena = |state[4:7];  // B0-B3 states
    assign counting  = state[8];     // Count state
    assign done      = state[9];     // Wait state

endmodule