module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding
    parameter [3:0] STATE_A = 4'b0001;
    parameter [3:0] STATE_B = 4'b0010;
    parameter [3:0] STATE_C = 4'b0100;
    parameter [3:0] STATE_D = 4'b1000;

    reg [3:0] state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        next_state = STATE_A;  // Default
        case (1'b1)  // Synopsys parallel_case
            state[0]: begin  // STATE_A
                if (r[0]) next_state = STATE_B;
                else if (r[1]) next_state = STATE_C;
                else if (r[2]) next_state = STATE_D;
                else next_state = STATE_A;
            end
            state[1]: next_state = r[0] ? STATE_B : STATE_A;  // STATE_B
            state[2]: next_state = r[1] ? STATE_C : STATE_A;  // STATE_C
            state[3]: next_state = r[2] ? STATE_D : STATE_A;  // STATE_D
        endcase
    end

    // State register (sequential)
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (combinational)
    always @(*) begin
        g = 3'b000;
        case (1'b1)  // Synopsys parallel_case
            state[1]: g[0] = 1'b1;  // STATE_B
            state[2]: g[1] = 1'b1;  // STATE_C
            state[3]: g[2] = 1'b1;  // STATE_D
        endcase
    end

endmodule