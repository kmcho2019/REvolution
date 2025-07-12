module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Define the state transition matrix
reg [2:0] state_transition_matrix [8][2];

// Initialize the state transition matrix
initial begin
    state_transition_matrix[0][0] = 3'b000; // State 0, input 0
    state_transition_matrix[0][1] = 3'b001; // State 0, input 1
    state_transition_matrix[1][0] = 3'b001; // State 1, input 0
    state_transition_matrix[1][1] = 3'b100; // State 1, input 1
    state_transition_matrix[2][0] = 3'b010; // State 2, input 0
    state_transition_matrix[2][1] = 3'b001; // State 2, input 1
    state_transition_matrix[3][0] = 3'b001; // State 3, input 0
    state_transition_matrix[3][1] = 3'b010; // State 3, input 1
    state_transition_matrix[4][0] = 3'b011; // State 4, input 0
    state_transition_matrix[4][1] = 3'b100; // State 4, input 1
    state_transition_matrix[5][0] = 3'b011; // State 5, input 0 ( unused )
    state_transition_matrix[5][1] = 3'b011; // State 5, input 1 ( unused )
    state_transition_matrix[6][0] = 3'b011; // State 6, input 0 ( unused )
    state_transition_matrix[6][1] = 3'b011; // State 6, input 1 ( unused )
    state_transition_matrix[7][0] = 3'b011; // State 7, input 0 ( unused )
    state_transition_matrix[7][1] = 3'b011; // State 7, input 1 ( unused )
end

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

// Combinational logic for next state and output
always @ (*) begin
    case (y)
        3'b000: next_state = x? state_transition_matrix[0][1] : state_transition_matrix[0][0];
        3'b001: next_state = x? state_transition_matrix[1][1] : state_transition_matrix[1][0];
        3'b010: next_state = x? state_transition_matrix[2][1] : state_transition_matrix[2][0];
        3'b011: next_state = x? state_transition_matrix[3][1] : state_transition_matrix[3][0];
        3'b100: next_state = x? state_transition_matrix[4][1] : state_transition_matrix[4][0];
        default: next_state = 3'b000;
    endcase
    
    // Directly assign output z based on current state
    z = (y == 3'b011 || y == 3'b100);
end

// Directly assign output Y0 from next_state
assign Y0 = next_state[0];

endmodule