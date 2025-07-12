module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   in,
    output reg [23:0] out_bytes,
    output reg        done
);

    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10
    } state_t;

    state_t state, next_state;
    reg [1:0] byte_count;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            out_bytes <= 24'd0;
            done      <= 1'b0;
            byte_count <= 2'd0;
        end else begin
            state <= next_state;
            done  <= 1'b0;

            case (state)
                IDLE: begin
                    // Wait for in[3] == 1 to start message capture
                    if (in[3]) begin
                        out_bytes <= {16'd0, in}; // Load first byte at lowest byte
                        byte_count <= 2'd1;
                    end
                end

                BYTE1: begin
                    // Shift left by 8 bits and insert new byte at LSB
                    out_bytes <= {out_bytes[15:0], in};
                    byte_count <= 2'd2;
                end

                BYTE2: begin
                    out_bytes <= {out_bytes[15:0], in};
                    done <= 1'b1; // Signal done in cycle after third byte
                    byte_count <= 2'd0; // Ready for next message
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = (in[3]) ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule