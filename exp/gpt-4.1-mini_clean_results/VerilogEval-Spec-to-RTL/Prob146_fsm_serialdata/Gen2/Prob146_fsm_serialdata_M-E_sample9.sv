module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg [7:0]  out_byte,
    output reg        done
);

    // State encoding (one-hot style for clarity)
    localparam IDLE    = 3'b001;
    localparam START   = 3'b010;
    localparam DATA    = 3'b011;
    localparam STOP    = 3'b100;
    localparam RECOVER = 3'b101;

    reg [2:0] state, next_state;

    reg [2:0] bit_index;      // count bits received [0..7]
    reg [7:0] shift_reg;

    // Sequential logic for state and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_index <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done pulse

            case (state)
                IDLE: begin
                    // Wait for start bit detected (0)
                    // Nothing else to update
                end
                START: begin
                    // Confirm start bit still zero
                    // Nothing else to update here
                end
                DATA: begin
                    // Shift in data bit LSB first
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_index <= bit_index + 1;
                end
                STOP: begin
                    // Check stop bit (should be 1)
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1; // pulse done signal
                    end
                    // bit_index stays unchanged here
                end
                RECOVER: begin
                    // Wait for line to return to idle (1) to start new byte
                end
                default: ;
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            IDLE: begin
                if (in == 1'b0) // Start bit detected
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                if (in == 1'b0) // Confirm start bit stable
                    next_state = DATA;
                else
                    next_state = IDLE; // false start, back to idle
            end
            DATA: begin
                if (bit_index == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;    // good stop bit, next byte
                else
                    next_state = RECOVER; // bad stop bit, wait for idle line
            end
            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule