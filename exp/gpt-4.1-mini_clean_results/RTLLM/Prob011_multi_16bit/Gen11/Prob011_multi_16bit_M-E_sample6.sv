module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg       done
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam CALC = 1'b1;

    reg state, next_state;

    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [31:0] product;
    reg [4:0]  bit_count;

    // State register
    always @(posedge clk or negedge rst_n) begin
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
                    next_state = CALC;
                else
                    next_state = IDLE;
            CALC:
                if (bit_count == 5'd16)
                    next_state = IDLE;
                else
                    next_state = CALC;
            default: next_state = IDLE;
        endcase
    end

    // Main datapath and control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            product      <= 32'd0;
            bit_count    <= 5'd0;
            yout         <= 32'd0;
            done         <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    bit_count <= 5'd0;
                    product <= 32'd0;
                    if (start) begin
                        multiplicand <= ain;
                        multiplier   <= bin;
                    end
                    yout <= product; // hold last product during idle
                end
                CALC: begin
                    // Accumulate if LSB of multiplier is 1
                    if (multiplier[0] == 1'b1)
                        product <= product + {16'd0, multiplicand};
                    else
                        product <= product;

                    // Shift multiplier right by 1 for next bit
                    multiplier <= multiplier >> 1;
                    bit_count <= bit_count + 1'b1;

                    yout <= product; // update output continuously

                    if (bit_count == 5'd15) begin
                        done <= 1'b1;
                    end
                end
                default: begin
                    multiplicand <= 16'd0;
                    multiplier <= 16'd0;
                    product <= 32'd0;
                    bit_count <= 5'd0;
                    yout <= 32'd0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule