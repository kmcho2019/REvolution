module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam WAIT_FOR_START = 3'b001;
    localparam BYTE_2         = 3'b010;
    localparam BYTE_3         = 3'b100;

    reg [2:0] state, next_state;

    // Use a 24-bit shift register to hold the three-byte message
    reg [23:0] shift_reg;

    // Sequential logic: state and shift_reg update
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            shift_reg <= 24'b0;
        end else begin
            state <= next_state;
            // Shift in bytes only in message capturing states
            case (state)
                WAIT_FOR_START: begin
                    if (in[3]) begin
                        // First byte found: load it into the MSB byte of shift_reg
                        shift_reg <= {in, 16'b0};
                    end
                end
                BYTE_2: begin
                    // Shift in the second byte into middle byte position
                    shift_reg <= {shift_reg[15:0], in};
                end
                BYTE_3: begin
                    // Shift in the third byte into LSB position
                    shift_reg <= {shift_reg[15:0], in};
                end
                default: shift_reg <= shift_reg;
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            WAIT_FOR_START: next_state = in[3] ? BYTE_2 : WAIT_FOR_START;
            BYTE_2:         next_state = BYTE_3;
            BYTE_3:         next_state = WAIT_FOR_START;
            default:        next_state = WAIT_FOR_START;
        endcase
    end

    // Output logic combinationally derived from state and shift_reg
    always @(*) begin
        done = (state == BYTE_3);  // Done asserted for one cycle right after third byte received
        out_bytes = done ? shift_reg : 24'bx; // valid output only when done asserted
    end

endmodule