module multi_8bit (
    input        clk,
    input        rst_n,
    input        start,
    input  [7:0] A,
    input  [7:0] B,
    output reg       done,
    output reg [15:0] product
);

    reg [15:0] multiplicand;
    reg [7:0]  multiplier;
    reg [15:0] accumulator;
    reg [3:0]  count; // count 0 to 8

    typedef enum logic [1:0] {
        IDLE,
        CALC,
        DONE
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
            IDLE:  next_state = (start) ? CALC : IDLE;
            CALC:  next_state = (count == 8) ? DONE : CALC;
            DONE:  next_state = (start) ? CALC : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier <= 8'd0;
            accumulator <= 16'd0;
            count <= 4'd0;
            product <= 16'd0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        multiplicand <= {8'b0, A};
                        multiplier <= B;
                        accumulator <= 16'd0;
                        count <= 4'd0;
                    end
                end
                CALC: begin
                    if (multiplier[0] == 1'b1)
                        accumulator <= accumulator + multiplicand;
                    multiplicand <= multiplicand << 1;
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