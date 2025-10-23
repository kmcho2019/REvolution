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
reg [2:0] state; // One-hot encoding scheme

// Reset logic
always @(posedge clk) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
        state <= 3'b001; // Initial state
    end
end

// State machine logic
always @(posedge clk) begin
    case (state)
        3'b001: begin // Reset state
            multiplicand <= {{8{b[7]}}, b};
            multiplier <= {{8{a[7]}}, a};
            state <= 3'b010; // Move to multiplication state
        end
        3'b010: begin // Multiplication state
            if (ctr < 16) begin
                // Left shift the multiplicand
                multiplicand <= multiplicand << 1;
                // Check the current bit of the multiplier
                if (multiplier[ctr] == 1) begin
                    // Accumulate the product
                    product <= product + multiplicand;
                end
                // Increment the counter
                ctr <= ctr + 1;
            end else begin
                state <= 3'b100; // Move to output state
            end
        end
        3'b100: begin // Output state
            p <= product;
            rdy <= 1;
            state <= 3'b001; // Move back to reset state
        end
        default: begin
            state <= 3'b001; // Default state
        end
    endcase
end

endmodule