module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [4:0] ctr;
reg [15:0] product;
reg [1:0] state;

// Combinational logic for state transitions
assign next_state = (state == 0 && ~reset)? 1 :
                     (state == 1 && ctr < 16)? 1 :
                     (state == 1 && ctr >= 16)? 2 :
                     (state == 2)? 0 : 0;

// Sequential logic for registers
always @(posedge clk) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
        state <= 0;
    end else begin
        case (state)
            0: begin
                // Reset the registers and set the initial state
                multiplicand <= {{8{b[7]}}, b};
                multiplier <= {{8{a[7]}}, a};
                state <= next_state;
            end
            1: begin
                // Perform the multiplication process
                if (multiplier[ctr] == 1) begin
                    // Accumulate the product
                    product <= product + multiplicand;
                end
                // Left shift the multiplicand
                multiplicand <= multiplicand << 1;
                // Increment the counter
                ctr <= ctr + 1;
                state <= next_state;
            end
            2: begin
                // Output the product and set the ready signal
                p <= product;
                rdy <= 1;
                state <= next_state;
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

endmodule