module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // State Decoder
    wire [9:0] curr_state;
    assign curr_state = state;

    // FSM Controller
    reg [9:0] next_state;
    always @(*) begin
        case (curr_state)
            10'b0000000001: // S
                if (~d) next_state = 10'b0000000001; // S
                else next_state = 10'b0000000010; // S1
            10'b0000000010: // S1
                if (~d) next_state = 10'b0000000001; // S
                else next_state = 10'b0000000100; // S11
            10'b0000000100: // S11
                if (~d) next_state = 10'b0000001000; // S110
                else next_state = 10'b0000000100; // S11
            10'b0000001000: // S110
                if (~d) next_state = 10'b0000000001; // S
                else next_state = 10'b0000010000; // B0
            10'b0000010000: // B0
                next_state = 10'b0000100000; // B1
            10'b0000100000: // B1
                next_state = 10'b0001000000; // B2
            10'b0001000000: // B2
                next_state = 10'b0010000000; // B3
            10'b0010000000: // B3
                next_state = 10'b0100000000; // Count
            10'b0100000000: // Count
                if (~done_counting) next_state = 10'b0100000000; // Count
                else next_state = 10'b1000000000; // Wait
            10'b1000000000: // Wait
                if (~ack) next_state = 10'b1000000000; // Wait
                else next_state = 10'b0000000001; // S
            default: next_state = 10'b0000000001; // S (default)
        endcase
    end

    // Output Logic
    reg shift_ena_reg, counting_reg, done_reg;
    always @(*) begin
        shift_ena_reg = 1'b0;
        counting_reg = 1'b0;
        done_reg = 1'b0;

        case (curr_state)
            10'b0000010000, // B0
            10'b0000100000, // B1
            10'b0001000000, // B2
            10'b0010000000: // B3
                shift_ena_reg = 1'b1;
            10'b0100000000: // Count
                counting_reg = 1'b1;
            10'b1000000000: // Wait
                done_reg = 1'b1;
            default: ;
        endcase
    end

    assign B3_next = next_state[7];
    assign S_next = next_state[0];
    assign S1_next = next_state[1];
    assign Count_next = next_state[8];
    assign Wait_next = next_state[9];
    assign done = done_reg;
    assign counting = counting_reg;
    assign shift_ena = shift_ena_reg;

endmodule