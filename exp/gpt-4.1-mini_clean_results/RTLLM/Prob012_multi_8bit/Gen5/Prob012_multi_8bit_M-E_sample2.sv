module multi_8bit (
    input            clk,
    input            rst_n,
    input      [7:0] A,
    input      [7:0] B,
    input            start,
    output reg [15:0] product,
    output reg       done
);
    reg [15:0] multiplicand;
    reg [7:0]  multiplier;
    reg [3:0]  bit_cnt;

    typedef enum logic [1:0] {
        IDLE,
        CALC,
        DONE
    } state_t;

    state_t state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = start ? CALC : IDLE;
            CALC:   next_state = (bit_cnt == 4'd8) ? DONE : CALC;
            DONE:   next_state = start ? CALC : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Control logic and multiplication
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product      <= 16'd0;
            multiplicand <= 16'd0;
            multiplier   <= 8'd0;
            bit_cnt      <= 4'd0;
            done         <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    done         <= 1'b0;
                    product      <= 16'd0;
                    bit_cnt      <= 4'd0;
                    if (start) begin
                        multiplicand <= {8'd0, A}; // Align A to LSB of 16-bit
                        multiplier   <= B;
                    end
                end
                CALC: begin
                    // Check current LSB of multiplier, add multiplicand if bit is 1
                    if (multiplier[0])
                        product <= product + multiplicand;

                    multiplicand <= multiplicand << 1;    // Shift multiplicand left each cycle
                    multiplier   <= multiplier >> 1;      // Shift multiplier right to next bit
                    bit_cnt      <= bit_cnt + 1;
                end
                DONE: begin
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule