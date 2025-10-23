module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Optimized FSM states
    localparam IDLE     = 1'b0;
    localparam RECEIVE  = 1'b1;

    reg state, next_state;
    reg [7:0] shift_reg;

    // FSM state transition and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'hFF;  // Initialize to all 1s (idle state)
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0;

            case (state)
                IDLE: begin
                    if (in == 0) begin  // Start bit detected
                        shift_reg <= 8'h00;  // Initialize for reception
                    end
                end

                RECEIVE: begin
                    // Shift in new bit (LSB first) only when receiving
                    shift_reg <= {in, shift_reg[7:1]};

                    // When 8 bits received, check stop bit
                    if (&shift_reg[6:0]) begin  // All bits shifted in
                        if (in == 1) begin  // Valid stop bit
                            out_byte <= {in, shift_reg[7:1]};
                            done <= 1;
                        end
                    end
                end
            endcase
        end
    end

    // Next state logic - simplified
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 0) ? RECEIVE : IDLE;
            end

            RECEIVE: begin
                // Stay in RECEIVE until we get a valid stop bit after 8 bits
                if ((&shift_reg[6:0]) && (in == 1)) begin
                    next_state = IDLE;
                end else begin
                    next_state = RECEIVE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule