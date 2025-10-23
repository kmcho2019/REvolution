module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (2-bit binary)
    localparam IDLE     = 2'b00;
    localparam DATA     = 2'b01;
    localparam STOP     = 2'b10;
    localparam RECOVERY = 2'b11;

    reg [1:0] state, next_state;

    reg [7:0] shift_reg;   // Holds received bits, LSB first
    reg [2:0] bit_count;   // Counts data bits 0 to 7

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter and shift register
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
                DATA: begin
                    // Shift left by 1, insert new bit at LSB (serial LSB-first)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 3'd1;
                end
                default: begin
                    // no change to shift_reg or bit_count
                end
            endcase
        end
    end

    // done and out_byte register
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default no done pulse
            if (state == STOP && in == 1'b1) begin
                // Valid stop bit, byte complete
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // hold by default
        case(state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = DATA;
            end
            DATA: begin
                // After receiving 8 bits (bit_count=7 after next bit),
                // move to STOP on next clock
                if (bit_count == 3'd7)
                    next_state = STOP;
            end
            STOP: begin
                // Check stop bit (should be 1)
                if (in == 1'b1)
                    next_state = IDLE;    // good stop bit, ready for next byte
                else
                    next_state = RECOVERY; // bad stop bit, wait for idle line
            end
            RECOVERY: begin
                // Wait until line goes idle (1)
                if (in == 1'b1)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule