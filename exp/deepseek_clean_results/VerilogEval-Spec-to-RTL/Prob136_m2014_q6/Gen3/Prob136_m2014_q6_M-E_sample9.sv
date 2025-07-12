module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    parameter [5:0] A = 6'b000001;
    parameter [5:0] B = 6'b000010;
    parameter [5:0] C = 6'b000100;
    parameter [5:0] D = 6'b001000;
    parameter [5:0] E = 6'b010000;
    parameter [5:0] F = 6'b100000;

    reg [5:0] current_state, next_state;

    // Next state logic (parallel AND-OR structure)
    always @(*) begin
        next_state = 6'b0;
        // State A transitions
        next_state[0] = current_state[0] & w;
        next_state[1] = current_state[0] & ~w;
        
        // State B transitions
        next_state[2] = current_state[1] & ~w;
        next_state[3] = current_state[1] & w;
        
        // State C transitions
        next_state[4] = current_state[2] & ~w;
        next_state[3] = current_state[2] & w | next_state[3];
        
        // State D transitions
        next_state[5] = current_state[3] & ~w;
        next_state[0] = current_state[3] & w | next_state[0];
        
        // State E transitions
        next_state[4] = current_state[4] & ~w | next_state[4];
        next_state[3] = current_state[4] & w | next_state[3];
        
        // State F transitions
        next_state[2] = current_state[5] & ~w | next_state[2];
        next_state[3] = current_state[5] & w | next_state[3];
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            z <= 1'b0;
        end
        else begin
            current_state <= next_state;
            // Registered output (1 in states E or F)
            z <= next_state[4] | next_state[5];
        end
    end

endmodule