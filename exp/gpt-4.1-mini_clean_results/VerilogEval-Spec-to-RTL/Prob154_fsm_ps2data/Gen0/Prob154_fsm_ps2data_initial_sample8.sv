module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        BYTE2 = 2'd1,
        BYTE3 = 2'd2
    } state_t;

    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // Next state logic
    always @(*) begin
        done = 1'b0;
        next_state = state;
        case(state)
            IDLE: begin
                if(in[3]) // found byte1 candidate
                    next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                // After byte3, next byte can be start of next message or discard
                if(in[3])
                    next_state = BYTE2;
                else
                    next_state = IDLE;
                done = 1'b1; // done asserted after byte3 received
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    if(in[3]) begin
                        byte1 <= in;
                    end
                end
                BYTE2: begin
                    byte2 <= in;
                end
                BYTE3: begin
                    byte3 <= in;
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                end
            endcase
            // Clear done signal if we are not in BYTE3 state
            if(state != BYTE3)
                done <= 1'b0;
        end
    end

endmodule