module multi_booth_8bit (
    input  clk, 
    input  reset, 
    input  [7:0] a, 
    input  [7:0] b, 
    output [15:0] p, 
    output rdy
);

reg [15:0] multiplier;
reg [15:0] multiplicand;
reg [15:0] product;
reg [4:0] ctr;
reg state;

always @(posedge clk or posedge reset) 
begin
    if (reset) begin
        // Initialize multiplier and multiplicand registers
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        product <= 16'b0;
        ctr <= 5'b0;
        state <= 1'b0;
        rdy <= 1'b0;
    end
    else if (!reset) begin
        if (state == 1'b0) begin
            // Check if counter is less than 16
            if (ctr < 16) begin
                state <= 1'b1;
            end
        end
        else if (state == 1'b1) begin
            // Left-shift multiplicand register
            multiplicand <= multiplicand << 1;
            
            // Check current bit of multiplier register
            if (multiplier[ctr] == 1'b1) begin
                // Accumulate value of multiplicand register into product register
                product <= product + multiplicand;
            end
            
            // Increment counter
            ctr <= ctr + 1;
            
            // Check if counter has reached 16
            if (ctr == 16) begin
                // Set ready signal to 1
                rdy <= 1'b1;
                state <= 1'b0;
            end
        end
    end
end

assign p = product;

endmodule