module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    typedef enum logic [1:0] {
        IDLE  = 2'd0,
        BYTE2 = 2'd1,
        BYTE3 = 2'd2
    } state_t;

    state_t state, next_state;

    // Sequential logic: state and output registers
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0;  // default no done unless third byte received

            case(state)
                IDLE: begin
                    if (in[3]) begin
                        // Start message, store first byte at MSB
                        out_bytes <= {in, 16'd0};
                    end
                end
                BYTE2: begin
                    // Shift left 8 bits and insert new byte at MSB
                    out_bytes <= {in, out_bytes[23:8]};
                end
                BYTE3: begin
                    // Shift left 8 bits and insert new byte at MSB, assert done
                    out_bytes <= {in, out_bytes[23:8]};
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = (in[3]) ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule