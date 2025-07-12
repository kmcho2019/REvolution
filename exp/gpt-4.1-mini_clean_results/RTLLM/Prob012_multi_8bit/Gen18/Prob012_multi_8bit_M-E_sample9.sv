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
    reg [3:0]  count;   // to count up to 8 cycles

    // State machine states
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'b0;
            multiplier   <= 8'b0;
            accumulator  <= 16'b0;
            count        <= 4'd0;
            product      <= 16'b0;
            done         <= 1'b0;
            state        <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        // Initialize operands and counters
                        multiplicand <= {8'b0, A}; // extend A to 16-bit
                        multiplier   <= B;
                        accumulator  <= 16'b0;
                        count        <= 4'd0;
                        state        <= BUSY;
                    end
                end
                BUSY: begin
                    // Check LSB of multiplier; add multiplicand if bit is 1
                    if (multiplier[0])
                        accumulator <= accumulator + multiplicand;

                    // Shift multiplicand left by 1
                    multiplicand <= multiplicand << 1;
                    // Shift multiplier right by 1
                    multiplier <= multiplier >> 1;

                    count <= count + 1;

                    if (count == 4'd7) begin
                        product <= accumulator;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule