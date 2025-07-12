module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Define the lookup tables for next state and output
    reg [3:0] next_state_lut [4][2];
    reg [1:0] out_lut [4];

    // Initialize the lookup tables
    initial begin
        next_state_lut[0][0] = 4'b0001; // A, in=0
        next_state_lut[0][1] = 4'b0010; // A, in=1
        next_state_lut[1][0] = 4'b0100; // B, in=0
        next_state_lut[1][1] = 4'b0010; // B, in=1
        next_state_lut[2][0] = 4'b0001; // C, in=0
        next_state_lut[2][1] = 4'b1000; // C, in=1
        next_state_lut[3][0] = 4'b0100; // D, in=0
        next_state_lut[3][1] = 4'b0010; // D, in=1

        out_lut[0] = 1'b0; // A
        out_lut[1] = 1'b0; // B
        out_lut[2] = 1'b0; // C
        out_lut[3] = 1'b1; // D
    end

    // Use the lookup tables to determine next state and output
    always @(*) begin
        case (state)
            4'b0001: next_state = next_state_lut[0][in];
            4'b0010: next_state = next_state_lut[1][in];
            4'b0100: next_state = next_state_lut[2][in];
            4'b1000: next_state = next_state_lut[3][in];
            default: next_state = 4'bxxxx;
        endcase

        case (state)
            4'b0001: out = out_lut[0];
            4'b0010: out = out_lut[1];
            4'b0100: out = out_lut[2];
            4'b1000: out = out_lut[3];
            default: out = 1'b0;
        endcase
    end

endmodule