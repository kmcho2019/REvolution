module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam [5:0] A = 6'b000001,
                     B = 6'b000010,
                     C = 6'b000100,
                     D = 6'b001000,
                     E = 6'b010000,
                     F = 6'b100000;

    reg [5:0] current_state, next_state;

    // Individual next state assignments for each transition
    assign next_state[0] = (current_state == A && ~w) || 
                          (current_state == D && ~w);
    
    assign next_state[1] = (current_state == A && w);
    
    assign next_state[2] = (current_state == B && w) || 
                          (current_state == F && w);
    
    assign next_state[3] = (current_state == B && ~w) || 
                          (current_state == C && ~w) || 
                          (current_state == D && w) || 
                          (current_state == E && ~w) || 
                          (current_state == F && ~w);
    
    assign next_state[4] = (current_state == C && w) || 
                          (current_state == E && w);
    
    assign next_state[5] = (current_state == D && w);

    // State storage with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Output is 1 when in state E or F
    assign z = current_state[4] | current_state[5];

endmodule