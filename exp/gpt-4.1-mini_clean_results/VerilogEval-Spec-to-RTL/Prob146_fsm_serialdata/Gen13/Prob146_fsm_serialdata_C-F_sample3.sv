module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam STOP_CHECK = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;

    reg [2:0] bit_count;   // Counts 0 to 7 for data bits
    reg [7:0] shift_reg;   // Shift register for data bits

    // Register to sample input 'in' to break combinational path at stop bit checking
    reg in_reg;

    wire shift_en  = (state == RECEIVE);
    wire count_en  = (state == RECEIVE);

    // Sample input 'in' synchronously to reduce critical path in stop bit verification
    always @(posedge clk) begin
        if (reset)
            in_reg <= 1'b1; // Idle line default high
        else
            in_reg <= in;
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in_reg == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = RECEIVE;
            end

            STOP_CHECK: begin
                if (in_reg == 1'b1)
                    next_state = IDLE;      // Valid stop bit
                else
                    next_state = WAIT_STOP; // Invalid stop bit, wait for idle line
            end

            WAIT_STOP: begin
                if (in_reg == 1'b1)
                    next_state = IDLE;      // Line idle regained
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Bit counter: reset at IDLE or STOP_CHECK/WAIT_STOP, increment in RECEIVE
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == IDLE)
            bit_count <= 3'd0;
        else if (count_en)
            bit_count <= bit_count + 3'd1;
        else if ((state == STOP_CHECK) || (state == WAIT_STOP))
            bit_count <= 3'd0;
    end

    // Shift register: shift right, LSB first reception, insert new bit at MSB
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (shift_en)
            shift_reg <= {in_reg, shift_reg[7:1]};
    end

    // Output done signal and output byte
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            if (state == STOP_CHECK && in_reg == 1'b1) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end else begin
                done <= 1'b0;
                // Preserve out_byte value to avoid unnecessary toggling when done is low
            end
        end
    end

endmodule