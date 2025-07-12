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

    reg [2:0] bit_count;      // count 0 to 7 for data bits
    reg [7:0] shift_reg;      // shift register for data bits

    wire shift_en;            // enable shift register update
    wire count_en;            // enable bit counter increment

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = state;  // default hold
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;         // valid stop bit
                else
                    next_state = WAIT_STOP;    // invalid stop bit, wait for idle
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;         // line idle regained
            end

            default: next_state = IDLE;
        endcase
    end

    // Shift enable when receiving data bits
    assign shift_en = (state == RECEIVE);

    // Bit counter enable when receiving bits
    assign count_en = (state == RECEIVE);

    // Bit counter with synchronous reset and enable
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == IDLE)
            bit_count <= 3'd0;
        else if (count_en)
            bit_count <= bit_count + 3'd1;
        else if (state == STOP_CHECK || state == WAIT_STOP)
            bit_count <= 3'd0;
    end

    // Shift register: shift right, insert new bit at MSB (LSB first reception)
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (shift_en)
            shift_reg <= {in, shift_reg[7:1]};
    end

    // done and out_byte registers
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else if (state == STOP_CHECK && in == 1'b1) begin
            done <= 1'b1;
            out_byte <= shift_reg;
        end else begin
            done <= 1'b0;
            // Keep out_byte unchanged to avoid toggling when done is low
        end
    end

endmodule