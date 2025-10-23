module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

integer i;
reg next_bit;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        // Determine next MSB based on current LSB
        next_bit = ~Q[0];
        
        // Shift right by one bit and set MSB to next_bit
        // Assign bits individually
        for (i = 63; i > 0; i = i - 1) begin
            Q[i] <= Q[i-1];
        end
        Q[0] <= next_bit;
    end
end

endmodule