module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    wire [3:0] A = 4'b0001;
    wire [3:0] B = 4'b0010;
    wire [3:0] C = 4'b0100;
    wire [3:0] D = 4'b1000;

    // Lookup tables for next state and output
    wire [3:0] next_state_lut [4:0] = {
        A,  // A, in=0
        B,  // A, in=1
        C,  // B, in=0
        B,  // B, in=1
        A,  // C, in=0
        D,  // C, in=1
        C,  // D, in=0
        B   // D, in=1
    };

    wire [0:0] out_lut [4:0] = {
        1'b0,  // A, in=0
        1'b0,  // A, in=1
        1'b0,  // B, in=0
        1'b0,  // B, in=1
        1'b0,  // C, in=0
        1'b0,  // C, in=1
        1'b1,  // D, in=0
        1'b1   // D, in=1
    };

    // Determine the index for the LUTs based on the current state and input
    wire [2:0] lut_index;
    always @(*) begin
        case (state)
            A: lut_index = in? 3'd1 : 3'd0;
            B: lut_index = in? 3'd3 : 3'd2;
            C: lut_index = in? 3'd5 : 3'd4;
            D: lut_index = in? 3'd7 : 3'd6;
            default: lut_index = 3'd0;
        endcase
    end

    // Assign the next state and output using the LUTs
    assign next_state = next_state_lut[lut_index];
    assign out = out_lut[lut_index];

endmodule