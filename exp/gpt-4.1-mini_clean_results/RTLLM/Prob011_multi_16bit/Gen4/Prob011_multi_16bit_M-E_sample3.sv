module multi_16bit (
    input         clk,
    input         rst_n,
    input         start,
    input  [15:0] ain,
    input  [15:0] bin,
    output [31:0] yout,
    output        done
);

    reg [4:0] count;           // iteration counter: 0 to 16
    reg done_r;
    reg [31:0] product;        // accumulating product
    reg [31:0] multiplicand;  // shifted multiplicand (ain shifted left)
    reg [15:0] multiplier;    // shifting multiplier right

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
        case(state)
            IDLE:
                if (start)
                    next_state = BUSY;
                else
                    next_state = IDLE;
            BUSY:
                if (count == 16)
                    next_state = DONE;
                else
                    next_state = BUSY;
            DONE:
                if (!start)
                    next_state = IDLE;
                else
                    next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 0;
        else if(state == IDLE)
            count <= 0;
        else if(state == BUSY)
            count <= count + 1;
        else
            count <= count;
    end

    // Registers update: multiplicand, multiplier, product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 32'b0;
            multiplier   <= 16'b0;
            product      <= 32'b0;
            done_r       <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    done_r <= 1'b0;
                    if (start) begin
                        multiplicand <= {16'b0, ain}; // zero extend multiplicand
                        multiplier   <= bin;
                        product      <= 32'b0;
                    end
                end
                BUSY: begin
                    // If LSB of multiplier is 1, add multiplicand to product
                    if (multiplier[0])
                        product <= product + multiplicand;
                    else
                        product <= product;

                    multiplicand <= multiplicand << 1; // shift multiplicand left by 1
                    multiplier   <= multiplier >> 1;   // shift multiplier right by 1

                    if (count == 16)
                        done_r <= 1'b1;
                end
                DONE: begin
                    done_r <= 1'b1;
                end
                default: begin
                    done_r <= 1'b0;
                end
            endcase
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule