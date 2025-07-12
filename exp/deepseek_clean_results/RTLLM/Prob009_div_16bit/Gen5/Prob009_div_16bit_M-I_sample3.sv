module div_16bit (
    input clk,            // Clock for input registers
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] A_reg;
reg [7:0] B_reg;
wire [15:0] ext_divisor = {8'b0, B_reg};
reg div_by_zero;

// Input registers to reduce switching activity
always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
end

// Division by zero check (only when B changes)
always @(B_reg) begin
    div_by_zero = (B_reg == 8'b0);
end

// Main division logic
always @(*) begin
    reg [7:0] rem;
    reg [15:0] quot;
    reg [15:0] dividend;
    integer i;
    
    if (div_by_zero) begin
        result = 16'hFFFF;
        odd = 16'hFFFF;
    end
    else begin
        rem = 8'b0;
        quot = 16'b0;
        dividend = A_reg;
        
        // Process 4 bits at a time (4 stages)
        for (i = 3; i >= 0; i = i - 1) begin
            // Stage 1: Bits 15-12
            rem = {rem[6:0], dividend[4*i+3]};
            if (rem >= B_reg) begin
                quot[4*i+3] = 1'b1;
                rem = rem - B_reg;
            end
            
            // Stage 2: Bits 11-8
            rem = {rem[6:0], dividend[4*i+2]};
            if (rem >= B_reg) begin
                quot[4*i+2] = 1'b1;
                rem = rem - B_reg;
            end
            
            // Stage 3: Bits 7-4
            rem = {rem[6:0], dividend[4*i+1]};
            if (rem >= B_reg) begin
                quot[4*i+1] = 1'b1;
                rem = rem - B_reg;
            end
            
            // Stage 4: Bits 3-0
            rem = {rem[6:0], dividend[4*i]};
            if (rem >= B_reg) begin
                quot[4*i] = 1'b1;
                rem = rem - B_reg;
            end
        end
        
        result = quot;
        odd = {8'b0, rem};  // Zero-extend final remainder
    end
end

endmodule