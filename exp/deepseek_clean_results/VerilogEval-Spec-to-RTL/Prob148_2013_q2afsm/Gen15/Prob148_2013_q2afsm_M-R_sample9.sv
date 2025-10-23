module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding (4 states)
    parameter [3:0] STATE_A = 4'b0001;
    parameter [3:0] STATE_B = 4'b0010;
    parameter [3:0] STATE_C = 4'b0100;
    parameter [3:0] STATE_D = 4'b1000;

    reg [3:0] current_state, next_state;

    // Combinational logic for next state and outputs
    always @(*) begin
        // Default next state (stay in current)
        next_state = current_state;
        
        case (1'b1) // synthesis parallel_case
            current_state[0]: begin // STATE_A
                if (r[0]) next_state = STATE_B;
                else if (r[1]) next_state = STATE_C;
                else if (r[2]) next_state = STATE_D;
            end
            current_state[1]: next_state = r[0] ? STATE_B : STATE_A; // STATE_B
            current_state[2]: next_state = r[1] ? STATE_C : STATE_A; // STATE_C
            current_state[3]: next_state = r[2] ? STATE_D : STATE_A; // STATE_D
        endcase
    end

    // Sequential state flip-flops
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= STATE_A;
        end else begin
            current_state <= next_state;
        end
    end

    // Output assignments (continuous)
    assign g[0] = current_state[1]; // STATE_B
    assign g[1] = current_state[2]; // STATE_C
    assign g[2] = current_state[3]; // STATE_D

endmodule