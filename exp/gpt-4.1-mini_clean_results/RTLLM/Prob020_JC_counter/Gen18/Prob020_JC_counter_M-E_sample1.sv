module JC_counter (
    input  wire       clk,    // Clock signal for synchronous operation
    input  wire       rst_n,  // Asynchronous active-low reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

// Split Q into two 32-bit halves
reg [31:0] high_half;
reg [31:0] low_half;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Asynchronous reset sets both halves to zero
        high_half <= 32'b0;
        low_half  <= 32'b0;
        Q <= 64'b0;
    end else begin
        // Calculate the new MSBs for each half as the inversion of the other half's LSB
        wire new_high_msb = ~low_half[0];
        wire new_low_msb  = ~high_half[0];

        // Shift right by 1 and insert the new MSB in each half
        high_half <= {new_high_msb, high_half[31:1]};
        low_half  <= {new_low_msb,  low_half[31:1]};
        
        // Concatenate the halves to form the full 64-bit Johnson counter output
        Q <= {high_half, low_half};
    end
end

endmodule