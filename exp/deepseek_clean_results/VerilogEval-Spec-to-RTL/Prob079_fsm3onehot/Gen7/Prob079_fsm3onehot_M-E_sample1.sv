module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Current state decoder (one-hot to binary-like)
    wire [1:0] curr_state;
    assign curr_state[0] = state[1] | state[3]; // States B or D
    assign curr_state[1] = state[2] | state[3]; // States C or D

    // Next state logic based on encoded current state and input
    reg [3:0] next_state_reg;
    always @(*) begin
        case ({curr_state, in})
            3'b000: next_state_reg = 4'b0001; // A, in=0 -> A
            3'b001: next_state_reg = 4'b0010; // A, in=1 -> B
            3'b010: next_state_reg = 4'b0100; // B, in=0 -> C
            3'b011: next_state_reg = 4'b0010; // B, in=1 -> B
            3'b100: next_state_reg = 4'b0001; // C, in=0 -> A
            3'b101: next_state_reg = 4'b1000; // C, in=1 -> D
            3'b110: next_state_reg = 4'b0100; // D, in=0 -> C
            3'b111: next_state_reg = 4'b0010; // D, in=1 -> B
            default: next_state_reg = 4'b0001;
        endcase
    end

    assign next_state = next_state_reg;
    assign out = (state == 4'b1000); // Output is 1 only in state D

endmodule