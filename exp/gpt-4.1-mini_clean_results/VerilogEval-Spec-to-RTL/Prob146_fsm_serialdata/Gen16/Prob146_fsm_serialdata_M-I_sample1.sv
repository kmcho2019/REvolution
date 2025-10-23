module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding with localparams for simpler synthesis
    localparam IDLE      = 2'b00,
               RECEIVE   = 2'b01,
               STOP      = 2'b10,
               WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)          // Detect start bit (line goes low)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Enable signal for shift register and bit counter
    wire shift_enable = (state == RECEIVE);

    // Data shift and bit_count update with enable to reduce switching
    always @(posedge clk) begin
        if (reset) begin
            bit_count  <= 3'd0;
            data_shift <= 8'd0;
        end else if (state == IDLE && in == 1'b0) begin
            // Clear registers at start bit detection
            bit_count  <= 3'd0;
            data_shift <= 8'd0;
        end else if (shift_enable) begin
            // Shift in LSB first: shift right and insert new bit at MSB
            data_shift <= {in, data_shift[7:1]};
            bit_count <= bit_count + 1;
        end
        // No else: registers hold their value without unnecessary toggling
    end

    // Output logic and done signal generation
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // Default deassert done

            // Assert done on the cycle stop bit is detected correctly in STOP state
            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

endmodule