module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output        done
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam BYTE2 = 2'b01;
    localparam BYTE3 = 2'b10;

    reg [1:0] state, next_state;

    // 24-bit shift register to hold the 3-byte message
    reg [23:0] shift_reg;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Shift register update: shift in new byte only when accepting a valid byte
    // Valid bytes accepted in states IDLE (if sync), BYTE2, BYTE3
    wire accept_byte = (state == IDLE && in[3]) || (state == BYTE2) || (state == BYTE3);

    always @(posedge clk) begin
        if (reset)
            shift_reg <= 24'd0;
        else if (accept_byte)
            shift_reg <= {shift_reg[15:0], in};
    end

    // Assign output and done combinationally
    // done asserted exactly 1 cycle after receiving third byte,
    // which corresponds to the cycle when state transitions from BYTE3 to IDLE
    reg state_dly;
    always @(posedge clk) begin
        if (reset)
            state_dly <= 1'b0;
        else
            state_dly <= (state == BYTE3);
    end

    assign done = (state == IDLE) && state_dly;

    always @(posedge clk) begin
        if (done)
            out_bytes <= shift_reg;
    end

endmodule