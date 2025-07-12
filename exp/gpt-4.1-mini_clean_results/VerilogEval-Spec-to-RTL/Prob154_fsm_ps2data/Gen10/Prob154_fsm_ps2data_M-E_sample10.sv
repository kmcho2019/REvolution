module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM states
    typedef enum reg [0:0] {
        IDLE = 1'b0,
        READING = 1'b1
    } state_t;

    state_t state, next_state;

    reg [1:0] byte_count;       // counts received bytes in current message (1 to 3)
    reg [23:0] shift_reg;       // shift register to hold 3-byte message

    // Next state logic and data updates
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            byte_count <= 2'd0;
            shift_reg  <= 24'd0;
            out_bytes  <= 24'd0;
            done       <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            case(state)
                IDLE: begin
                    byte_count <= 2'd0;
                    if (in[3]) begin
                        // Start byte detected
                        shift_reg <= {16'd0, in}; // left-justify start byte at lowest 8 bits
                        byte_count <= 2'd1;
                        state <= READING;
                    end
                end

                READING: begin
                    // Shift in new byte, shifting previous bytes to higher bits
                    shift_reg <= {shift_reg[15:0], in};
                    byte_count <= byte_count + 1'b1;

                    if (byte_count == 2'd2) begin
                        // After receiving third byte (byte_count==3), output and done
                        out_bytes <= {shift_reg[15:0], in};
                        done <= 1'b1;
                        state <= IDLE;
                        byte_count <= 2'd0;
                    end
                end
            endcase
        end
    end

endmodule