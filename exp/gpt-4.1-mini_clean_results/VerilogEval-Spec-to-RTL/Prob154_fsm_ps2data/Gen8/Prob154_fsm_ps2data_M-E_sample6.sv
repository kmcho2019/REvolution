module TopModule(
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg    done
);

    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;

    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2, byte3;

    // State transition logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:  if (in[3]) next_state = BYTE1;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state and registers
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            done      <= 1'b0;
            out_bytes <= 24'b0;
            byte1     <= 8'b0;
            byte2     <= 8'b0;
            byte3     <= 8'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0;  // default done low

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

                BYTE3: begin
                    // Output message and signal done
                    out_bytes <= {byte1, byte2, in};
                    done      <= 1'b1;
                end
            endcase
        end
    end

endmodule