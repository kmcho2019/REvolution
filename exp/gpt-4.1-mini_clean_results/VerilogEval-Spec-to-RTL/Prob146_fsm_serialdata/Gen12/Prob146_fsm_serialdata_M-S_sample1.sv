module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (2 bits)
    localparam IDLE      = 2'b00;
    localparam RECEIVING = 2'b01;
    localparam WAIT_STOP = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;     // 0 to 7
    reg [7:0] shift_reg;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter register
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (state == RECEIVING)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Shift register capturing data bits, LSB first
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == RECEIVING)
            shift_reg <= {in, shift_reg[7:1]};
        else if (state == IDLE)
            shift_reg <= 8'd0;
    end

    // Output done signal and out_byte when a valid stop bit received
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0;
            if (state == WAIT_STOP && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0) // Detect start bit
                    next_state = RECEIVING;
                else
                    next_state = IDLE;
            end

            RECEIVING: begin
                if (bit_cnt == 3'd7)
                    next_state = WAIT_STOP;
                else
                    next_state = RECEIVING;
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // Valid stop bit, back to idle
                else
                    next_state = WAIT_STOP; // Wait until stop bit appears
            end

            default: next_state = IDLE;
        endcase
    end

endmodule