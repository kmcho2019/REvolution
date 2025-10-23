module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output rdy
);

    // State encoding
    localparam CALC = 1'b0;
    localparam DONE = 1'b1;
    reg state;

    // Internal registers
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg prev_lsb;
    reg [2:0] iter_ctr;

    // Booth encoding signals
    wire [1:0] current_bits = multiplier[1:0];
    wire [15:0] booth_add = 
        (current_bits == 2'b01 || current_bits == 2'b10) ? multiplicand :
        (current_bits == 2'b11 && !prev_lsb) ? (multiplicand << 1) :
        (current_bits == 2'b00 && prev_lsb) ? -(multiplicand << 1) :
        (current_bits == 2'b10 && prev_lsb) ? -multiplicand :
        (current_bits == 2'b01 && !prev_lsb) ? multiplicand : 16'b0;

    // Ready signal generation
    assign rdy = (state == DONE);

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            prev_lsb <= 1'b0;
            iter_ctr <= 3'b0;
            state <= CALC;
        end else begin
            case (state)
                CALC: begin
                    // Accumulate Booth result
                    p <= p + booth_add;

                    // Update registers
                    multiplicand <= multiplicand << 2;
                    prev_lsb <= multiplier[1];
                    multiplier <= {{2{multiplier[15]}}, multiplier[15:2]}; // Arithmetic right shift

                    // Check completion
                    if (iter_ctr == 3'd4) begin
                        state <= DONE;
                    end
                    iter_ctr <= iter_ctr + 1;
                end

                DONE: begin
                    // Hold state until reset
                    state <= DONE;
                end
            endcase
        end
    end

endmodule