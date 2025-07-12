module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // Binary state encoding
    localparam [1:0]
        IDLE       = 2'd0,
        RECEIVE    = 2'd1,
        STOP       = 2'd2,
        ERROR_WAIT = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;  // Start bit detected
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Valid stop bit
                else
                    next_state = ERROR_WAIT; // Invalid stop bit
            end

            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter logic
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (state == IDLE)
            bit_cnt <= 3'd0;
        else if (state == RECEIVE)
            bit_cnt <= bit_cnt + 3'd1;
    end

    // Shift register loads LSB first during RECEIVE state
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == IDLE)
            shift_reg <= 8'd0;
        else if (state == RECEIVE)
            shift_reg <= {in, shift_reg[7:1]};
    end

    // out_byte registered when valid stop bit detected (in STOP state)
    always @(posedge clk) begin
        if (reset)
            out_byte <= 8'd0;
        else if (state == STOP && in == 1'b1)
            out_byte <= shift_reg;
    end

    // done pulse asserted one cycle when valid stop bit detected
    always @(posedge clk) begin
        if (reset)
            done <= 1'b0;
        else
            done <= (state == STOP && in == 1'b1);
    end

endmodule