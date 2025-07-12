module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    localparam STATE_A = 4'b0001;
    localparam STATE_B = 4'b0010;
    localparam STATE_C = 4'b0100;
    localparam STATE_D = 4'b1000;

    reg [3:0] current_state, next_state;

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (!resetn)
            current_state <= STATE_A;
        else
            current_state <= next_state;
    end

    // Combined state transition and output logic
    always @(*) begin
        // Default outputs
        g = 3'b000;
        next_state = STATE_A;

        case (1'b1) // synthesis parallel_case
            current_state[0]: begin // STATE_A
                if (r[0]) begin
                    next_state = STATE_B;
                    g[0] = 1'b1;
                end
                else if (r[1]) begin
                    next_state = STATE_C;
                    g[1] = 1'b1;
                end
                else if (r[2]) begin
                    next_state = STATE_D;
                    g[2] = 1'b1;
                end
                else begin
                    next_state = STATE_A;
                end
            end
            current_state[1]: begin // STATE_B
                g[0] = 1'b1;
                if (r[0])
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end
            current_state[2]: begin // STATE_C
                g[1] = 1'b1;
                if (r[1])
                    next_state = STATE_C;
                else
                    next_state = STATE_A;
            end
            current_state[3]: begin // STATE_D
                g[2] = 1'b1;
                if (r[2])
                    next_state = STATE_D;
                else
                    next_state = STATE_A;
            end
        endcase
    end

endmodule