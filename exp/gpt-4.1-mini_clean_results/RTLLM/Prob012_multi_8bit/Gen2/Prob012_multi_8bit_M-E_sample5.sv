module multi_8bit (
    input          clk,
    input          rst_n,
    input  [7:0]   A,
    input  [7:0]   B,
    input          start,
    output reg [15:0] product,
    output reg     ready
);

    reg [15:0] multiplicand;
    reg [7:0]  multiplier;
    reg [15:0] accumulator;
    reg [3:0]  count;  // Count from 0 to 8

    typedef enum reg [1:0] {IDLE, RUNNING, DONE} state_t;
    state_t state, next_state;

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = start ? RUNNING : IDLE;
            RUNNING: next_state = (count == 4'd8) ? DONE : RUNNING;
            DONE:   next_state = start ? RUNNING : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Main sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'b0;
            multiplier   <= 8'b0;
            accumulator  <= 16'b0;
            count        <= 4'b0;
            product      <= 16'b0;
            ready        <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    ready <= 1'b0;
                    if (start) begin
                        multiplicand <= {8'b0, A}; // zero-extend A to 16 bits
                        multiplier   <= B;
                        accumulator  <= 16'b0;
                        count        <= 4'b0;
                    end
                end
                RUNNING: begin
                    if (multiplier[0]) begin
                        accumulator <= accumulator + multiplicand;
                    end
                    multiplicand <= multiplicand << 1;
                    multiplier   <= multiplier >> 1;
                    count       <= count + 1;
                end
                DONE: begin
                    product <= accumulator;
                    ready   <= 1'b1;
                end
            endcase
        end
    end

endmodule