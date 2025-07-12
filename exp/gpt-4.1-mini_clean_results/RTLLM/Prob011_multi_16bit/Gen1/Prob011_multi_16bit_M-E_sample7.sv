module multi_16bit (
    input         clk,
    input         rst_n,
    input         start,
    input  [15:0] ain,
    input  [15:0] bin,
    output [31:0] yout,
    output        done
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'd0,
        BUSY = 2'd1,
        DONE = 2'd2
    } state_t;

    reg [1:0] state, next_state;

    reg [4:0] count;       // 0 to 16 counting the bits processed
    reg [31:0] product;    // Accumulator for the product
    reg [15:0] multiplicand;
    reg [15:0] multiplier;

    // FSM state transitions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = start ? BUSY : IDLE;
            BUSY:  next_state = (count == 16) ? DONE : BUSY;
            DONE:  next_state = start ? BUSY : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 5'd0;
        else if (state == IDLE)
            count <= 5'd0;
        else if (state == BUSY)
            count <= count + 5'd1;
    end

    // Registers for multiplicand, multiplier, and product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            product      <= 32'd0;
        end else begin
            case(state)
                IDLE: begin
                    if (start) begin
                        multiplicand <= ain;
                        multiplier   <= bin;
                        product      <= 32'd0;
                    end
                end
                BUSY: begin
                    // If LSB of multiplier is 1, add multiplicand shifted by count to product
                    if (multiplier[0])
                        product <= product + {16'd0, multiplicand};
                    else
                        product <= product;
                    // Shift multiplicand left by 1 and multiplier right by 1
                    multiplicand <= multiplicand << 1;
                    multiplier   <= multiplier >> 1;
                end
                DONE: begin
                    // Hold the product steady until start or reset
                    product <= product;
                    multiplicand <= multiplicand;
                    multiplier <= multiplier;
                end
            endcase
        end
    end

    assign yout = product;
    assign done = (state == DONE);

endmodule