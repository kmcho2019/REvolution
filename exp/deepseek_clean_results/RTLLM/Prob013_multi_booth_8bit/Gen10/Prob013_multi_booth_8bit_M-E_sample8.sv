module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // States for the multiplier
    typedef enum {INIT, CALC, DONE} state_t;
    reg [1:0] state;

    // Internal registers
    reg [15:0] multiplicand;
    reg [15:0] neg_multiplicand;
    reg [15:0] twice_multiplicand;
    reg [15:0] neg_twice_multiplicand;
    reg [15:0] multiplier;
    reg [2:0] iter_ctr;
    reg prev_lsb;

    // Pre-compute all possible Booth operations
    always @(posedge clk) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            neg_multiplicand <= -{{8{a[7]}}, a};
            twice_multiplicand <= {{8{a[7]}}, a} << 1;
            neg_twice_multiplicand <= -({{8{a[7]}}, a} << 1);
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            iter_ctr <= 3'd4;  // Count down from 4 (5 iterations)
            prev_lsb <= 1'b0;
            state <= INIT;
            rdy <= 1'b0;
        end else begin
            case (state)
                INIT: begin
                    state <= CALC;
                end

                CALC: begin
                    // Parallel prefix adder implementation
                    reg [15:0] booth_result;
                    reg [15:0] sum, carry;
                    
                    // Booth encoding (selection only)
                    case ({multiplier[1:0], prev_lsb})
                        3'b000, 3'b111: booth_result = 16'b0;
                        3'b001, 3'b010: booth_result = multiplicand;
                        3'b101, 3'b110: booth_result = neg_multiplicand;
                        3'b011: booth_result = twice_multiplicand;
                        3'b100: booth_result = neg_twice_multiplicand;
                    endcase

                    // Kogge-Stone adder implementation (first stage)
                    sum = p ^ booth_result;
                    carry = p & booth_result;

                    // Second stage (carry propagation)
                    sum = sum ^ (carry << 1);
                    carry = (sum & (carry << 1)) | (carry & (carry << 1));

                    // Final accumulation
                    p <= sum + (carry << 1);

                    // Update for next iteration
                    prev_lsb <= multiplier[1];
                    multiplier <= $signed(multiplier) >>> 2;

                    if (iter_ctr == 3'd0) begin
                        state <= DONE;
                        rdy <= 1'b1;
                    end else begin
                        iter_ctr <= iter_ctr - 1;
                    end
                end

                DONE: begin
                    // Maintain state until next reset
                    state <= DONE;
                end
            endcase
        end
    end

endmodule