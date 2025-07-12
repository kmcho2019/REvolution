module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM states
    typedef enum logic [0:0] {IDLE=1'b0, COLLECT=1'b1} state_t;
    state_t state, next_state;

    // Shift register for bytes collected (24-bit)
    reg [23:0] msg_shift;
    // 2-bit counter to count bytes after start byte (0..2)
    reg [1:0] byte_count;

    // FSM next state and outputs logic combinational
    always @(*) begin
        done = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = COLLECT;
                end
            end
            COLLECT: begin
                if (byte_count == 2'd2) begin
                    done = 1'b1;
                    next_state = IDLE;
                end
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            msg_shift  <= 24'd0;
            byte_count <= 2'd0;
            out_bytes  <= 24'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    done <= 1'b0;
                    byte_count <= 2'd0;
                    if (in[3]) begin
                        // Load start byte at highest 8 bits
                        msg_shift <= {in, 16'd0};
                        byte_count <= 2'd0; // Will increment on next COLLECT cycle
                    end else begin
                        msg_shift <= 24'd0;
                    end
                end

                COLLECT: begin
                    if (byte_count < 2'd2) begin
                        // Shift left by 8 bits and insert new byte at LSB
                        msg_shift <= {msg_shift[15:0], in};
                        byte_count <= byte_count + 1'b1;
                        done <= 1'b0;
                    end else begin
                        // Final byte received, shift in and output message
                        msg_shift <= {msg_shift[15:0], in};
                        out_bytes <= {msg_shift[15:0], in};
                        done <= 1'b1;
                        byte_count <= 2'd0;
                    end
                end
            endcase
        end
    end

endmodule