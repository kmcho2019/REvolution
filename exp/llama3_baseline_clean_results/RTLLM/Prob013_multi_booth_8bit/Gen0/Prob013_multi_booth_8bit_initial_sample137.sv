module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output [15:0] p,
    output rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [4:0] ctr;
reg [15:0] product;
reg ready;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        // Initialize registers on reset
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        ctr <= 0;
        product <= 0;
        ready <= 0;
    end else begin
        if(ctr < 16) begin
            // Shift multiplicand for the next operation
            multiplicand <= multiplicand << 1;
            
            // Perform Booth operation based on the current bit of the multiplier
            case({multiplier[ctr+1], multiplier[ctr]})
                2'b00: begin
                    // Do nothing
                end
                2'b01: begin
                    // Add multiplicand
                    product <= product + multiplicand;
                end
                2'b10: begin
                    // Subtract multiplicand
                    product <= product - multiplicand;
                end
                2'b11: begin
                    // Do nothing, as per Booth algorithm for this encoding
                end
            endcase
            
            // Increment counter
            ctr <= ctr + 1;
        end else begin
            // If counter reaches 16, multiplication is complete, set ready signal
            ready <= 1;
        end
    end
end

// Output the product and ready signal
assign p = product;
assign rdy = ready;

endmodule