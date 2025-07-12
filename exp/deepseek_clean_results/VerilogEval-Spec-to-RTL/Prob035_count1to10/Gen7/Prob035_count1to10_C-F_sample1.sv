module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

localparam RESET_VAL = 4'b0001;  // Reset to 1
parameter START      = RESET_VAL; // Starting value
parameter END        = 4'b1010;   // Ending value (10)

always @(posedge clk) begin
    if (reset) begin
        q <= RESET_VAL;           // Synchronous reset to 1
    end
    else begin
        // Efficient check for END value (1010) using only q[3] & q[1]
        q <= (q[3] & q[1]) ? START : q + 1'b1;
    end
end

endmodule