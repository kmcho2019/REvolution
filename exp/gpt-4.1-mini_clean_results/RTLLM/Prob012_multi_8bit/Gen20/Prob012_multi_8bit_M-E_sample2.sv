module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output reg  [15:0] product,
    output reg         ready
);

    reg [15:0] multiplicand;
    reg [7:0]  multiplier;
    reg [3:0]  count;       // Count up to 8 cycles

    // Internal product register to accumulate result
    reg [15:0] product_reg;

    // State machine states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BUSY = 2'b01,
        DONE = 2'b10
    } state_t;

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
        case (state)
            IDLE:  next_state = start ? BUSY : IDLE;
            BUSY:  next_state = (count == 4'd8) ? DONE : BUSY;
            DONE:  next_state = start ? BUSY : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Control and data path
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier   <= 8'd0;
            product_reg  <= 16'd0;
            count        <= 4'd0;
            product      <= 16'd0;
            ready        <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    ready <= 1'b0;
                    product <= 16'd0;
                    product_reg <= 16'd0;
                    count <= 4'd0;
                    if (start) begin
                        multiplicand <= {8'd0, A}; // Zero extend A to 16 bits
                        multiplier <= B;
                    end
                end
                BUSY: begin
                    // If LSB of multiplier is 1, add multiplicand to product_reg
                    if (multiplier[0])
                        product_reg <= product_reg + multiplicand;

                    // Shift multiplicand left by 1 for next bit
                    multiplicand <= multiplicand << 1;

                    // Shift multiplier right by 1 to process next bit
                    multiplier <= multiplier >> 1;

                    // Increment count
                    count <= count + 1;
                end
                DONE: begin
                    product <= product_reg;
                    ready <= 1'b1;
                end
            endcase
        end
    end

endmodule