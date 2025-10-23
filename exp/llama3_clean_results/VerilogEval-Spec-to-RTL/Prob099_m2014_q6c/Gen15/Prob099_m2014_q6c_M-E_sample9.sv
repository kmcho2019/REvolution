module TopModule(
    input [5:0] y,
    input w,
    output Y2,
    output Y4
);

// Define the state transition matrix for Y2 (corresponding to y[1])
// Each row corresponds to a current state (A to F), and each column to an input condition (w = 0 or w = 1)
// The value at row 'i' and column 'j' is 1 if the next state has y[1] = 1 when the current state is 'i' and w = 'j'
reg [1:0] Y2_transition_matrix[6:0];
always @(*) begin
    Y2_transition_matrix[0] = 2'b01; // From A, to B when w=0, stay in A when w=1
    Y2_transition_matrix[1] = 2'b10; // From B, to C when w=0, to D when w=1
    Y2_transition_matrix[2] = 2'b01; // From C, to E when w=0, to D when w=1
    Y2_transition_matrix[3] = 2'b11; // From D, to F when w=0, to A when w=1
    Y2_transition_matrix[4] = 2'b00; // From E, stay in E when w=0, to D when w=1
    Y2_transition_matrix[5] = 2'b10; // From F, to C when w=0, to D when w=1
end

// Define the state transition matrix for Y4 (corresponding to y[3])
reg [1:0] Y4_transition_matrix[6:0];
always @(*) begin
    Y4_transition_matrix[0] = 2'b00; // From A, to B when w=0, stay in A when w=1
    Y4_transition_matrix[1] = 2'b01; // From B, to C when w=0, to D when w=1
    Y4_transition_matrix[2] = 2'b01; // From C, to E when w=0, to D when w=1
    Y4_transition_matrix[3] = 2'b11; // From D, to F when w=0, to A when w=1
    Y4_transition_matrix[4] = 2'b00; // From E, stay in E when w=0, to D when w=1
    Y4_transition_matrix[5] = 2'b10; // From F, to C when w=0, to D when w=1
end

// Use the one-hot encoding of the current state to index into the transition matrix
// and determine the next state signals Y2 and Y4 based on the input w
always @(*) begin
    case (1'b1)
        y[0]: Y2 = Y2_transition_matrix[0][w];
        y[1]: Y2 = Y2_transition_matrix[1][w];
        y[2]: Y2 = Y2_transition_matrix[2][w];
        y[3]: Y2 = Y2_transition_matrix[3][w];
        y[4]: Y2 = Y2_transition_matrix[4][w];
        y[5]: Y2 = Y2_transition_matrix[5][w];
    endcase
    
    case (1'b1)
        y[0]: Y4 = Y4_transition_matrix[0][w];
        y[1]: Y4 = Y4_transition_matrix[1][w];
        y[2]: Y4 = Y4_transition_matrix[2][w];
        y[3]: Y4 = Y4_transition_matrix[3][w];
        y[4]: Y4 = Y4_transition_matrix[4][w];
        y[5]: Y4 = Y4_transition_matrix[5][w];
    endcase
end

endmodule