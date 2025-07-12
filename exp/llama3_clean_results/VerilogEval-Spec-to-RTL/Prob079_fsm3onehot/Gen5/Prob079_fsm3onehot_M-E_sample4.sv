module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Define state encoding as parameters
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    // State transition table as a lookup table
    wire [3:0] transition_table [3:0][1:0];
    assign transition_table[A][0] = A; // State A, in=0
    assign transition_table[A][1] = B; // State A, in=1
    assign transition_table[B][0] = C; // State B, in=0
    assign transition_table[B][1] = B; // State B, in=1
    assign transition_table[C][0] = A; // State C, in=0
    assign transition_table[C][1] = D; // State C, in=1
    assign transition_table[D][0] = C; // State D, in=0
    assign transition_table[D][1] = B; // State D, in=1

    // Output logic table as a lookup table
    wire [0:0] output_table [3:0];
    assign output_table[A] = 1'b0; // State A
    assign output_table[B] = 1'b0; // State B
    assign output_table[C] = 1'b0; // State C
    assign output_table[D] = 1'b1; // State D

    // State transition logic
    reg [3:0] current_state;
    always @(*) begin
        case(state)
            A: current_state = transition_table[A][in];
            B: current_state = transition_table[B][in];
            C: current_state = transition_table[C][in];
            D: current_state = transition_table[D][in];
            default: current_state = 4'bxxxx;
        endcase
    end
    assign next_state = current_state;

    // Output logic
    assign out = output_table[state];

endmodule