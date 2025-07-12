module TopModule (
    input clk,
    input ar,      // Asynchronous active-high reset
    input d,
    output reg q
);

localparam RESET_VALUE = 1'b0;

// D flip-flop with asynchronous reset and gated d sampling
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= RESET_VALUE;        // Asynchronous reset
    end else begin
        q <= d;                 // Sample d only when not in reset
    end
end

endmodule