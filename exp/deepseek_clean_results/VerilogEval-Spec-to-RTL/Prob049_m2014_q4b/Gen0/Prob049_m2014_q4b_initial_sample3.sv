module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;  // Asynchronous reset when ar is high
    end else begin
        q <= d;     // Positive edge-triggered D flip-flop behavior
    end
end

endmodule