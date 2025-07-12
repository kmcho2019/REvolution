module TopModule(
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output reg      out
);

    // Define state encoding
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Declare next state table: next_state_table[current_state][input]
    reg [1:0] next_state_table [0:3][0:1];
    // Declare output table: output_table[current_state]
    reg       output_table [0:3];

    integer i, j;

    initial begin
        // Initialize next state transitions
        next_state_table[A][0] = A; next_state_table[A][1] = B;
        next_state_table[B][0] = C; next_state_table[B][1] = B;
        next_state_table[C][0] = A; next_state_table[C][1] = D;
        next_state_table[D][0] = C; next_state_table[D][1] = B;

        // Initialize output values
        output_table[A] = 1'b0;
        output_table[B] = 1'b0;
        output_table[C] = 1'b0;
        output_table[D] = 1'b1;
    end

    always @(*) begin
        next_state = next_state_table[state][in];
        out = output_table[state];
    end

endmodule