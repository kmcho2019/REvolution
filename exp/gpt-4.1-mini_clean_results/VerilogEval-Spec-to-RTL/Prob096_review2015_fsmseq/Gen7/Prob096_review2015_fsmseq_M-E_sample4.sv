module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // One-hot state encoding: 
    // IDLE      = 00001 (no bits matched)
    // S1        = 00010 ('1' matched)
    // S11       = 00100 ("11" matched)
    // S110      = 01000 ("110" matched)
    // DETECTED  = 10000 ("1101" matched, final)

    reg [4:0] state, next_state;

    localparam IDLE     = 5'b00001;
    localparam S1       = 5'b00010;
    localparam S11      = 5'b00100;
    localparam S110     = 5'b01000;
    localparam DETECTED = 5'b10000;

    // State register with synchronous active-high reset
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
                if (data)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (data)
                    next_state = S11;
                else
                    next_state = IDLE;
            end

            S11: begin
                if (~data)
                    next_state = S110;
                else
                    next_state = S11;  // stay if '1', as prefix "11" repeats
            end

            S110: begin
                if (data)
                    next_state = DETECTED;
                else
                    next_state = IDLE;
            end

            DETECTED: begin
                // Latch here indefinitely until reset
                next_state = DETECTED;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic: start_shifting is 1 when in DETECTED state
    always @(posedge clk) begin
        if (reset)
            start_shifting <= 1'b0;
        else if (state == DETECTED)
            start_shifting <= 1'b1;
    end

endmodule