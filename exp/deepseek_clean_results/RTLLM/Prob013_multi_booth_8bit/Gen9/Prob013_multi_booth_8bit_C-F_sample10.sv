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
    reg [9:0] multiplicand;  // 8-bit + 2 shifts (10 bits)
    reg [7:0] multiplier;
    reg prev_lsb;
    reg [1:0] iter_ctr;      // 2-bit counter for 4 iterations
    reg [15:0] booth_result; // Registered booth operation result

    // Booth encoding
    always @(*) begin
        case ({multiplier[1:0], prev_lsb})
            3'b000, 3'b111: booth_result = 16'b0;
            3'b001, 3'b010: booth_result = {{6{multiplicand[9]}}, multiplicand};
            3'b011:         booth_result = {{5{multiplicand[9]}}, multiplicand, 1'b0};
            3'b100:         booth_result = -{{5{multiplicand[9]}}, multiplicand, 1'b0};
            3'b101, 3'b110: booth_result = -{{6{multiplicand[9]}}, multiplicand};
            default:        booth_result = 16'b0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {a[7], a[7], a};
            multiplier <= b;
            prev_lsb <= 1'b0;
            p <= 16'b0;
            iter_ctr <= 2'b0;
            state <= INIT;
            rdy <= 1'b0;
        end else begin
            case (state)
                INIT: begin
                    state <= CALC;
                    rdy <= 1'b0;
                end

                CALC: begin
                    // Accumulate registered booth result
                    p <= p + booth_result;

                    // Update registers for next iteration
                    multiplicand <= multiplicand << 2;
                    prev_lsb <= multiplier[1];
                    multiplier <= multiplier >> 2;

                    // Check completion (4 iterations)
                    if (iter_ctr == 2'b11) begin
                        state <= DONE;
                        rdy <= 1'b1;
                    end else begin
                        iter_ctr <= iter_ctr + 1;
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