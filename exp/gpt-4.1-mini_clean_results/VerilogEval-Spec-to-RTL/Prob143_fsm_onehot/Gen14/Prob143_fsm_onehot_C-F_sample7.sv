module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    reg [9:0] next_state_reg;
    integer i;

    always @* begin
        next_state_reg = 10'b0;

        for (i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                case (i)
                    0: next_state_reg[in ? 1 : 0] = 1'b1;  // S0
                    1: next_state_reg[in ? 2 : 0] = 1'b1;  // S1
                    2: next_state_reg[in ? 3 : 0] = 1'b1;  // S2
                    3: next_state_reg[in ? 4 : 0] = 1'b1;  // S3
                    4: next_state_reg[in ? 5 : 0] = 1'b1;  // S4
                    5: next_state_reg[in ? 6 : 8] = 1'b1;  // S5
                    6: next_state_reg[in ? 7 : 9] = 1'b1;  // S6
                    7: next_state_reg[in ? 7 : 0] = 1'b1;  // S7
                    8: next_state_reg[in ? 1 : 0] = 1'b1;  // S8
                    9: next_state_reg[in ? 1 : 0] = 1'b1;  // S9
                    default: ;
                endcase
            end
        end
    end

    // Output logic
    // out1 is high if state S8 or S9 is active
    // out2 is high if state S7 or S9 is active
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

    assign next_state = next_state_reg;

endmodule