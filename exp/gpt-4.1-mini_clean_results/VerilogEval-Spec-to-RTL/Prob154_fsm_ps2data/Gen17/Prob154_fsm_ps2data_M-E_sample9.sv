module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        DONE  = 2'b11
    } state_t;

    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end

                BYTE1: begin
                    byte2 <= in;
                end

                BYTE2: begin
                    byte3 <= in;
                end

                DONE: begin
                    // Update output with assembled message
                    out_bytes <= {byte1, byte2, byte3};
                    done <= 1'b1; // assert done on third byte received cycle
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = DONE;
            DONE:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule