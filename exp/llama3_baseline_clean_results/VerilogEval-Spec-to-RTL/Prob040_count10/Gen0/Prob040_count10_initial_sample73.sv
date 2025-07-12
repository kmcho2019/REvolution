module TopModule(clk, reset, q);
    input clk;
    input reset;
    output [3:0] q;
    reg [3:0] q;

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000; // Reset to 0 when reset is high
        end else if (q == 4'b1001) begin // Check for count value 10 (1010) but since we only count up to 9, we will check for 9 (1001) and reset to 0
            q <= 4'b0000; // Reset to 0 when count reaches 10 (but since we only go up to 9, we reset at 9)
        end else begin
            q <= q + 1; // Increment the counter otherwise
        end
    end
endmodule