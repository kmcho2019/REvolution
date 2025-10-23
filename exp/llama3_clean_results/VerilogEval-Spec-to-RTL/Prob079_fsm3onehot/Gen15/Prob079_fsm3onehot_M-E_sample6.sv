module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding defined as local parameters for modularity and readability
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // Define the LUTs for state transition logic and output logic
    reg [3:0] next_state_lut [3:0];
    reg [0:0] out_lut [3:0];

    // Initialize the LUTs based on the state transition table and output logic
    initial begin
        // For state A
        next_state_lut[0] = (in)? B : A;
        out_lut[0] = 1'b0;

        // For state B
        next_state_lut[1] = (in)? B : C;
        out_lut[1] = 1'b0;

        // For state C
        next_state_lut[2] = (in)? D : A;
        out_lut[2] = 1'b0;

        // For state D
        next_state_lut[3] = (in)? B : C;
        out_lut[3] = 1'b1;
    end

    // Assign the next state and output based on the current state and input
    always @(*) begin
        case(state)
            A: begin
                next_state = next_state_lut[0];
                out = out_lut[0];
            end
            B: begin
                next_state = next_state_lut[1];
                out = out_lut[1];
            end
            C: begin
                next_state = next_state_lut[2];
                out = out_lut[2];
            end
            D: begin
                next_state = next_state_lut[3];
                out = out_lut[3];
            end
            default: begin
                next_state = 4'bxxxx;
                out = 1'b0;
            end
        endcase
    end

endmodule