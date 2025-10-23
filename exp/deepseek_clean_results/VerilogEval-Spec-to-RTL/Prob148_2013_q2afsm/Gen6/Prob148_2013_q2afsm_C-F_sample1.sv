module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding
    localparam [3:0] STATE_A = 4'b0001,
                     STATE_B = 4'b0010,
                     STATE_C = 4'b0100,
                     STATE_D = 4'b1000;

    reg [3:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!resetn)
            state <= STATE_A;
        else
            state <= next_state;
    end

    // Next state logic with priority encoding
    always @(*) begin
        case (1'b1) // Synthesis will optimize this as a priority encoder
            state[0]: begin // STATE_A
                if (r[0])       next_state = STATE_B;
                else if (r[1])  next_state = STATE_C;
                else if (r[2])  next_state = STATE_D;
                else            next_state = STATE_A;
            end
            state[1]: begin // STATE_B
                next_state = r[0] ? STATE_B : STATE_A;
            end
            state[2]: begin // STATE_C
                next_state = r[1] ? STATE_C : STATE_A;
            end
            state[3]: begin // STATE_D
                next_state = r[2] ? STATE_D : STATE_A;
            end
            default: next_state = STATE_A;
        endcase
    end

    // Registered output generation
    always @(posedge clk) begin
        if (!resetn) begin
            g <= 3'b000;
        end else begin
            g[0] <= (next_state == STATE_B);
            g[1] <= (next_state == STATE_C);
            g[2] <= (next_state == STATE_D);
        end
    end

endmodule