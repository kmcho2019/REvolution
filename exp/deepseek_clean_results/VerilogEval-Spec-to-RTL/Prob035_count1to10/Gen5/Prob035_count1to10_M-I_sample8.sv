module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg terminal_count;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;          // Reset to 1
        terminal_count <= 1'b0;
    end
    else begin
        terminal_count <= (q == 4'b1010);  // Registered terminal count
        
        if (terminal_count) begin
            q <= 4'b0001;      // Wrap around to 1
        end
        else begin
            q <= q + 1;        // Increment count
        end
    end
end

endmodule