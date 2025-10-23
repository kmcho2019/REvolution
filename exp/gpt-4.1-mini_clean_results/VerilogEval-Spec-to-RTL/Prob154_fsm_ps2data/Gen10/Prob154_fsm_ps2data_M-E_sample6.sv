module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    state_t state, next_state;
    reg [23:0] shift_reg;

    // State transition and datapath
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            shift_reg  <= 24'd0;
            out_bytes  <= 24'd0;
            done       <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        // Load start byte into upper 8 bits
                        shift_reg <= {in, 16'd0};
                        state <= BYTE2;
                    end else begin
                        state <= IDLE;
                    end
                end
                BYTE2: begin
                    // Shift in second byte
                    shift_reg <= {shift_reg[15:0], in};
                    state <= BYTE3;
                end
                BYTE3: begin
                    // Shift in third byte
                    shift_reg <= {shift_reg[15:0], in};
                    out_bytes <= {shift_reg[15:0], in}; // Output full message
                    done <= 1'b1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule