module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding: 4 states
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam STOP_CHECK = 4'b0100;
    localparam RECOVER    = 4'b1000;

    reg [3:0] state, next_state;

    reg [2:0] bit_count;      // count bits 0..7
    reg [7:0] shift_reg;      // data bits shifted in (LSB first)
    reg       in_stop_reg;    // registered input at stop bit for timing improvement

    wire shift_en;
    wire count_en;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Register input during STOP_CHECK to break combinational path in done logic
    always @(posedge clk) begin
        if (reset)
            in_stop_reg <= 1'b1; // idle line default high
        else if (state == STOP_CHECK)
            in_stop_reg <= in;
        else
            in_stop_reg <= 1'b1; // keep high outside stop_check
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
            end

            STOP_CHECK: begin
                if (in_stop_reg == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Shift enable and count enable signals - only active during RECEIVE state
    assign shift_en = (state == RECEIVE);
    assign count_en = (state == RECEIVE);

    // Bit counter with synchronous reset and enable
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == IDLE)
            bit_count <= 3'd0;
        else if (count_en)
            bit_count <= bit_count + 3'd1;
        else if (state == STOP_CHECK || state == RECOVER)
            bit_count <= 3'd0;
    end

    // Shift register: shift right, new bit shifted in MSB (LSB first protocol)
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == IDLE)
            shift_reg <= 8'd0;
        else if (shift_en)
            shift_reg <= {in, shift_reg[7:1]};
    end

    // Output done and out_byte logic: pulse done one cycle on valid stop bit,
    // update out_byte only then, keep stable otherwise
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0;
            if (state == STOP_CHECK && in_stop_reg == 1'b1) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

endmodule