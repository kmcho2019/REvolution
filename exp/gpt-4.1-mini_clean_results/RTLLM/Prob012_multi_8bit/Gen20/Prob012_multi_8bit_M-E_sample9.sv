module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output reg  [15:0] product,
    output reg         done
);

    reg [15:0] multiplicand;
    reg [7:0]  multiplier;
    reg [15:0] accumulator;
    reg [3:0]  count;

    typedef enum logic [1:0] {IDLE, CALC, DONE} state_t;
    state_t state, next_state;

    // FSM sequential state update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = start ? CALC : IDLE;
            CALC:  next_state = (count == 4'd8) ? DONE : CALC;
            DONE:  next_state = start ? CALC : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Main multiplication process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product      <= 16'd0;
            multiplicand <= 16'd0;
            multiplier   <= 8'd0;
            accumulator  <= 16'd0;
            count        <= 4'd0;
            done         <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        multiplicand <= {8'd0, A}; // Extend A to 16 bits
                        multiplier   <= B;
                        accumulator  <= 16'd0;
                        count        <= 4'd0;
                    end
                end
                CALC: begin
                    // If LSB of multiplier is 1, add multiplicand to accumulator
                    if (multiplier[0])
                        accumulator <= accumulator + multiplicand;

                    // Shift multiplicand left by 1 for next bit position
                    multiplicand <= multiplicand << 1;

                    // Shift multiplier right by 1 (processing next bit)
                    multiplier <= multiplier >> 1;

                    count <= count + 1;
                end
                DONE: begin
                    product <= accumulator;
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule