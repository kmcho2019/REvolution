module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire terminal_count = (q == 10'd999);  // Direct comparison for simpler logic

always @(posedge clk) begin
    if (reset) begin
        q <= 10'b0;
    end
    else begin
        if (terminal_count) begin
            q <= 10'b0;
        end
        else begin
            q <= q + 1'b1;  // Simple ripple-carry adder is sufficient
        end
    end
end

endmodule