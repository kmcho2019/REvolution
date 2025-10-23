module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    typedef enum logic [2:0] {
        IDLE  = 3'd0,
        BYTE1 = 3'd1,
        BYTE2 = 3'd2,
        BYTE3 = 3'd3,
        DONE  = 3'd4
    } state_t;

    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // Sequential logic: state and data registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default done deasserted; will assert only in DONE state below
            done <= 1'b0;

            case (state)
                IDLE: begin
                    // Wait for a byte with in[3] == 1
                    // No bytes stored yet
                end
                BYTE1: begin
                    byte1 <= in;
                end
                BYTE2: begin
                    byte2 <= in;
                end
                BYTE3: begin
                    byte3 <= in;
                end
                DONE: begin
                    // Assert done and update out_bytes with full message
                    done <= 1'b1;
                    out_bytes <= {byte1, byte2, byte3};
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = DONE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule