module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Priority encoder to handle multiple active states
    wire [3:0] encoded_state;
    assign encoded_state = 
        state[9] ? 4'd9 :
        state[8] ? 4'd8 :
        state[7] ? 4'd7 :
        state[6] ? 4'd6 :
        state[5] ? 4'd5 :
        state[4] ? 4'd4 :
        state[3] ? 4'd3 :
        state[2] ? 4'd2 :
        state[1] ? 4'd1 :
        state[0] ? 4'd0 :
        4'd0;  // default to S0 if no state is active

    // State transition logic
    reg [9:0] next_state_reg;
    always @(*) begin
        case (encoded_state)
            4'd0: next_state_reg = in ? 10'b0000000010 : 10'b0000000001;  // S0
            4'd1: next_state_reg = in ? 10'b0000000100 : 10'b0000000001;  // S1
            4'd2: next_state_reg = in ? 10'b0000001000 : 10'b0000000001;  // S2
            4'd3: next_state_reg = in ? 10'b0000010000 : 10'b0000000001;  // S3
            4'd4: next_state_reg = in ? 10'b0000100000 : 10'b0000000001;  // S4
            4'd5: next_state_reg = in ? 10'b0001000000 : 10'b0010000000;  // S5
            4'd6: next_state_reg = in ? 10'b0100000000 : 10'b1000000000;  // S6
            4'd7: next_state_reg = in ? 10'b0100000000 : 10'b0000000001;  // S7
            4'd8: next_state_reg = in ? 10'b0000000010 : 10'b0000000001;  // S8
            4'd9: next_state_reg = in ? 10'b0000000010 : 10'b0000000001;  // S9
            default: next_state_reg = 10'b0000000001;  // default to S0
        endcase
    end

    assign next_state = next_state_reg;

    // Output logic - only S7, S8, S9 have non-zero outputs
    assign out1 = state[8] | state[9];  // S8 or S9
    assign out2 = state[7] | state[9];  // S7 or S9

endmodule