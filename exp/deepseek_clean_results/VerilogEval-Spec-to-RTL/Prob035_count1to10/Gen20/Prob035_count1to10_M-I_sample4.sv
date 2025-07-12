module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter RESET_VAL = 4'b0001;
reg is_ten;

always @(posedge clk) begin
    is_ten <= (q == 4'b1010);  // Registered comparison for better timing
    
    if (reset) begin
        q <= RESET_VAL;         // Parameterized reset value
    end
    else if (is_ten) begin     // Use registered comparison
        q <= RESET_VAL;         // Wrap around to 1
    end
    else begin
        q <= q + 4'b0001;       // Increment counter
    end
end

endmodule