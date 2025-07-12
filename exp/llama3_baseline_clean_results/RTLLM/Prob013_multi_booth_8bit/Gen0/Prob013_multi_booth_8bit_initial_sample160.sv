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

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= {{8{b[7]}}, b}; // Sign extension for multiplicand
        multiplier <= {{8{a[7]}}, a}; // Sign extension for multiplier
        p <= 0; // Initialize product
        ctr <= 0; // Reset counter
        rdy <= 0; // Reset ready signal
    end else if (ctr < 16) begin
        multiplicand <= multiplicand << 1; // Left shift multiplicand
        if (multiplier[ctr]) begin
            p <= p + multiplicand; // Accumulate product
        end
        ctr <= ctr + 1; // Increment counter
        rdy <= 0; // Ready signal is 0 during multiplication
    end else begin
        rdy <= 1; // Set ready signal to 1 when multiplication is complete
    end
end

endmodule