module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // States
    localparam IDLE     = 1'b0;
    localparam CAPTURE  = 1'b1;

    reg state, next_state;
    reg [9:0] shift_reg;  // Stores start + 8 data + stop bits
    reg done_reg;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 10'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            done_reg <= 1'b0;

            case (state)
                IDLE: begin
                    shift_reg <= 10'b0;
                    if (~in) begin  // Start bit detection (falling edge)
                        shift_reg <= {9'b0, in};  // Initialize with start bit
                    end
                end

                CAPTURE: begin
                    shift_reg <= {shift_reg[8:0], in};  // Shift in new bit

                    // When full, check protocol and generate done pulse
                    if (&shift_reg[9:1]) begin  // Check if all upper bits are set (full)
                        if (~shift_reg[9] && shift_reg[0] && in) begin  // Valid frame: start=0, stop=1
                            done_reg <= 1'b1;
                        end
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (~in) ? CAPTURE : IDLE;
            CAPTURE: begin
                if (&shift_reg[9:1]) begin  // Register full
                    next_state = IDLE;
                end else begin
                    next_state = CAPTURE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule