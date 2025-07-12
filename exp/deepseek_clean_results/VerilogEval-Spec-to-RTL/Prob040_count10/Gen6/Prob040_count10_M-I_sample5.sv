module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg terminal_count;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
        terminal_count <= 1'b0;
    end
    else begin
        terminal_count <= q[3] & q[0];  // Registered version of terminal count
        if (terminal_count) begin
            q <= 4'b0000;
        end
        else begin
            q <= q + 1'b1;
        end
    end
end

endmodule