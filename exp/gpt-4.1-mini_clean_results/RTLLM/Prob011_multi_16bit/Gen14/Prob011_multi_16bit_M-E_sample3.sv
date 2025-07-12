module multi_16bit (
    input          clk,
    input          rst_n,   // synchronous active-low reset
    input          start,
    input  [15:0]  ain,     // multiplicand
    input  [15:0]  bin,     // multiplier
    output reg [31:0] yout,
    output reg       done
);

    // FSM state definition
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        RUNNING = 2'b01,
        DONE    = 2'b10
    } state_t;

    state_t state, next_state;

    reg [4:0] count;           // counts from 0 to 16 (number of bits processed)
    reg [31:0] multiplicand_sh; // shifted multiplicand (left shifted every cycle)
    reg [15:0] multiplier_reg;  // shifted multiplier (right shifted every cycle)
    reg [31:0] product_reg;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:
                if (start)
                    next_state = RUNNING;
                else
                    next_state = IDLE;

            RUNNING:
                if (count == 5'd16)
                    next_state = DONE;
                else
                    next_state = RUNNING;

            DONE:
                if (!start)
                    next_state = IDLE;
                else
                    next_state = DONE;

            default:
                next_state = IDLE;
        endcase
    end

    // Data path and control logic
    always @(posedge clk) begin
        if (!rst_n) begin
            count          <= 5'd0;
            multiplicand_sh <= 32'd0;
            multiplier_reg <= 16'd0;
            product_reg    <= 32'd0;
            yout           <= 32'd0;
            done           <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    yout <= 32'd0;
                    count <= 5'd0;
                    if (start) begin
                        // Load inputs at start
                        multiplicand_sh <= {16'd0, ain};  // zero-extend and load multiplicand
                        multiplier_reg <= bin;
                        product_reg <= 32'd0;
                    end
                end

                RUNNING: begin
                    // Accumulate if LSB of multiplier is 1
                    if (multiplier_reg[0])
                        product_reg <= product_reg + multiplicand_sh;
                    else
                        product_reg <= product_reg;

                    // Shift multiplicand left by 1 to align next partial product
                    multiplicand_sh <= multiplicand_sh << 1;

                    // Shift multiplier right by 1 to process next bit
                    multiplier_reg <= multiplier_reg >> 1;

                    count <= count + 5'd1;

                    // done signal remains low until count hits 16
                    done <= 1'b0;
                    yout <= 32'd0;
                end

                DONE: begin
                    // Assert done flag and output final product
                    done <= 1'b1;
                    yout <= product_reg;
                    // Hold all registers until start is deasserted
                    count <= count;
                    multiplicand_sh <= multiplicand_sh;
                    multiplier_reg <= multiplier_reg;
                    product_reg <= product_reg;
                end

                default: begin
                    done <= 1'b0;
                    yout <= 32'd0;
                    count <= 5'd0;
                    multiplicand_sh <= 32'd0;
                    multiplier_reg <= 16'd0;
                    product_reg <= 32'd0;
                end
            endcase
        end
    end

endmodule