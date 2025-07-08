module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg        done
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;

    reg [7:0] byte1, byte2, byte3;
    reg [1:0] state, next_state;

    // Next state logic and data capture
    always @(*) begin
        // Default assignments
        done = 1'b0;
        next_state = state;

        case(state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    next_state = BYTE1;
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                done = 1'b1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
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
            done <= 1'b0; // default clear, done asserted combinationally

            case (state)
                IDLE: begin
                    if (in[3] == 1'b1) begin
                        byte1 <= in;
                    end
                end
                BYTE1: begin
                    byte2 <= in;
                end
                BYTE2: begin
                    byte3 <= in;
                end
                BYTE3: begin
                    // Assert done in this cycle and output the assembled message
                    done <= 1'b1;
                    out_bytes <= {byte1, byte2, in};
                end
            endcase
        end
    end

endmodule