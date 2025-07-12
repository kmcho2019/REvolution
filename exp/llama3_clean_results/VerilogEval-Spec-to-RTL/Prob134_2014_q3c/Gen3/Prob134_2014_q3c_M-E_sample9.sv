module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;
reg output_z;

// Lookup tables for next state and output
reg [2:0] next_state_table [8][2];
reg [7:0] output_table [8];

always @(posedge clk) begin
    current_state <= next_state;
end

always @(*) begin
    // Initialize next state table
    next_state_table[0][0] = 3'b000; // current state 000, x = 0
    next_state_table[0][1] = 3'b001; // current state 000, x = 1
    next_state_table[1][0] = 3'b001; // current state 001, x = 0
    next_state_table[1][1] = 3'b100; // current state 001, x = 1
    next_state_table[2][0] = 3'b010; // current state 010, x = 0
    next_state_table[2][1] = 3'b001; // current state 010, x = 1
    next_state_table[3][0] = 3'b001; // current state 011, x = 0
    next_state_table[3][1] = 3'b010; // current state 011, x = 1
    next_state_table[4][0] = 3'b011; // current state 100, x = 0
    next_state_table[4][1] = 3'b100; // current state 100, x = 1

    // Initialize output table
    output_table[0] = 8'b00000000; // current state 000
    output_table[1] = 8'b00000000; // current state 001
    output_table[2] = 8'b00000000; // current state 010
    output_table[3] = 8'b00000001; // current state 011
    output_table[4] = 8'b00000101; // current state 100

    // Determine next state
    if (x == 1'b0) begin
        case (current_state)
            3'b000: next_state = next_state_table[0][0];
            3'b001: next_state = next_state_table[1][0];
            3'b010: next_state = next_state_table[2][0];
            3'b011: next_state = next_state_table[3][0];
            3'b100: next_state = next_state_table[4][0];
            default: next_state = current_state;
        endcase
    end else begin
        case (current_state)
            3'b000: next_state = next_state_table[0][1];
            3'b001: next_state = next_state_table[1][1];
            3'b010: next_state = next_state_table[2][1];
            3'b011: next_state = next_state_table[3][1];
            3'b100: next_state = next_state_table[4][1];
            default: next_state = current_state;
        endcase
    end

    // Determine output z
    case (current_state)
        3'b000: output_z = output_table[0][0];
        3'b001: output_z = output_table[1][0];
        3'b010: output_z = output_table[2][0];
        3'b011: output_z = output_table[3][0];
        3'b100: output_z = output_table[4][0];
        default: output_z = 1'b0;
    endcase
end

assign Y0 = next_state[0];
assign z = output_z;

endmodule