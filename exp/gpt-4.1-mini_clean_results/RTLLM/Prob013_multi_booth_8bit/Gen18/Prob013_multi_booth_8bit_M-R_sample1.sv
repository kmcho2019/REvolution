module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,         // multiplier
    input      [7:0]  b,         // multiplicand
    output reg [15:0] p,         // product
    output reg        rdy         // ready
);

    // State encoding: IDLE = 0, CALC = 1
    reg state, next_state;

    // Registers for inputs and computation
    reg signed [15:0] multiplicand; // shifted each cycle
    reg signed [15:0] product;
    reg [15:0] multiplier;          // holds sign extended multiplier

    reg [4:0] ctr;                  // counts 0 to 16

    // Control signals
    wire cnt_en;
    wire add_en;

    // Next state logic
    always @(*) begin
        case(state)
            1'b0: // IDLE
                if (!reset)
                    next_state = 1'b1; // move to CALC after reset deasserted
                else
                    next_state = 1'b0;
            1'b1: // CALC
                if (ctr == 5'd16)
                    next_state = 1'b0; // back to IDLE when done
                else
                    next_state = 1'b1;
            default:
                next_state = 1'b0;
        endcase
    end

    // Counter enable: active in CALC and ctr < 16
    assign cnt_en = (state == 1'b1) && (ctr < 5'd16);

    // Add enable: if current multiplier bit at ctr is 1
    assign add_en = cnt_en && (multiplier[ctr] == 1'b1);

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 1'b0; // IDLE
            ctr <= 5'd0;
            multiplicand <= 16'sd0;
            multiplier <= 16'd0;
            product <= 16'sd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            state <= next_state;

            if (state == 1'b0) begin // IDLE state: load inputs and reset
                ctr <= 5'd0;
                // Sign extend inputs: a is multiplier, b is multiplicand
                multiplier <= { {8{a[7]}}, a };
                multiplicand <= { {8{b[7]}}, b };
                product <= 16'sd0;
                p <= 16'd0;
                rdy <= 1'b0;
            end else if (state == 1'b1) begin // CALC
                if (cnt_en) begin
                    ctr <= ctr + 1'b1;
                    // Add multiplicand to product if multiplier bit is 1
                    if (add_en)
                        product <= product + multiplicand;
                    else
                        product <= product;
                    // Shift multiplicand left by 1
                    multiplicand <= multiplicand <<< 1;
                end
                // Set output and ready when done
                if (ctr == 5'd15) begin
                    p <= product + (add_en ? multiplicand : 16'sd0);
                    rdy <= 1'b1;
                end else begin
                    rdy <= 1'b0;
                end
            end
        end
    end

endmodule