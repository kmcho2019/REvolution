module TopModule (
    input clk,          // Added clock for sequential implementation
    input [7:0] in,
    output reg parity   // Changed to reg for sequential assignment
);
    integer i;
    always @(posedge clk) begin
        parity = 1'b0;  // Initialize for even parity
        for (i = 0; i < 8; i = i + 1) begin
            parity = parity ^ in[i];
        end
    end
endmodule