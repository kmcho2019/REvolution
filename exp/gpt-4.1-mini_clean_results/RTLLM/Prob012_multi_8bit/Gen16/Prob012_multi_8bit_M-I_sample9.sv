module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,       // active low reset
    input  wire [7:0]  A,           // multiplicand
    input  wire [7:0]  B,           // multiplier
    input  wire        start,       // start signal to begin multiplication
    output reg  [15:0] product,     // multiplication result
    output reg         done         // done signal indicates product is valid
);

    reg [15:0] multiplicand_reg;    // shifted multiplicand
    reg [7:0]  multiplier_reg;      // shifting multiplier
    reg [3:0]  bit_cnt;             // counter from 0 to 7
    reg [15:0] partial_sum;         // accumulating product

    // State machine states (idle and busy)
    typedef enum reg {IDLE, BUSY} state_t;
    state_t state, next_state;

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and control
    always @(*) begin
        case(state)
            IDLE: next_state = start ? BUSY : IDLE;
            BUSY: next_state = (bit_cnt == 4'd8) ? IDLE : BUSY;
            default: next_state = IDLE;
        endcase
    end

    // Main sequential multiplication logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand_reg <= 16'd0;
            multiplier_reg   <= 8'd0;
            bit_cnt          <= 4'd0;
            partial_sum      <= 16'd0;
            product          <= 16'd0;
            done             <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        multiplicand_reg <= {8'd0, A};  // extend A to 16 bits
                        multiplier_reg   <= B;
                        bit_cnt          <= 4'd0;
                        partial_sum      <= 16'd0;
                    end
                end
                BUSY: begin
                    // Check LSB of multiplier_reg, add multiplicand if set
                    if (multiplier_reg[0])
                        partial_sum <= partial_sum + multiplicand_reg;
                    else
                        partial_sum <= partial_sum;

                    // Shift multiplicand left by 1, multiplier right by 1
                    multiplicand_reg <= multiplicand_reg << 1;
                    multiplier_reg   <= multiplier_reg >> 1;

                    bit_cnt <= bit_cnt + 1;

                    if (bit_cnt == 4'd7) begin
                        product <= partial_sum + (multiplier_reg[0] ? multiplicand_reg : 16'd0);
                        done <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule