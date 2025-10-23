module TopModule (
    input  wire        clk,
    input  wire        in,
    input  wire        reset,
    output reg  [7:0]  out_byte,
    output reg         done
);

    // One-hot state encoding
    localparam IDLE       = 5'b00001;
    localparam START_BIT  = 5'b00010;
    localparam DATA_BITS  = 5'b00100;
    localparam STOP_BIT   = 5'b01000;
    localparam WAIT_IDLE  = 5'b10000;

    reg [4:0] state, next_state;

    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Bit counter
    always @(posedge clk) begin
        if (reset || state != DATA_BITS)
            bit_count <= 3'd0;
        else if (state == DATA_BITS)
            bit_count <= bit_count + 1'b1;
    end

    // Shift register load on data bits
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'd0;
        end else if (state == DATA_BITS) begin
            // Shift right by one, new bit at MSB for LSB-first data reception
            // Incoming LSB first means first received bit is bit 0
            shift_reg <= {in, shift_reg[7:1]};
        end
    end

    // Output and done logic
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default no done pulse

            if (state == STOP_BIT) begin
                if (in == 1'b1) begin
                    // Valid stop bit, output byte and pulse done
                    out_byte <= shift_reg;
                    done <= 1'b1;
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0) // Detect start bit (line goes low)
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end
            START_BIT: begin
                // Sample start bit - it should be zero, but just move on next clock
                next_state = DATA_BITS;
            end
            DATA_BITS: begin
                if (bit_count == 3'd7)
                    next_state = STOP_BIT;
                else
                    next_state = DATA_BITS;
            end
            STOP_BIT: begin
                if (in == 1'b1) // Valid stop bit, return to IDLE
                    next_state = IDLE;
                else
                    next_state = WAIT_IDLE; // Wait for line to return to idle before new frame
            end
            WAIT_IDLE: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule