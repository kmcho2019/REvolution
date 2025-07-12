module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg        done
);

    // State encoding
    typedef enum logic [1:0] {
        WAIT_SYNC = 2'b00,
        BYTE2     = 2'b01,
        BYTE3     = 2'b10
    } state_t;

    state_t state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

    // Output and state register update (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state     <= WAIT_SYNC;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            case(next_state)
                WAIT_SYNC: begin
                    // discard bytes, done low
                    done <= 1'b0;
                    // out_bytes can be don't care; preserve or clear to 0
                    // To avoid unnecessary toggling, keep out_bytes unchanged here.
                end
                BYTE2: begin
                    // Store first byte as MSB of out_bytes (bits 23:16)
                    out_bytes[23:16] <= in;
                    done <= 1'b0;
                end
                BYTE3: begin
                    // Shift prior stored byte1 to middle, store current in LSB
                    out_bytes[15:8]  <= in;                 // second byte
                    done <= 1'b0;
                end
                default: begin
                    done <= 1'b0;
                end
            endcase

            if (state == BYTE3) begin
                // On current BYTE3 state, load third byte and assert done next cycle
                out_bytes[7:0] <= in;    // third byte (LSB)
                done <= 1'b1;
            end else if (state != BYTE3) begin
                done <= 1'b0;
            end
        end
    end

endmodule