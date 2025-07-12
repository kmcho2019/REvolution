module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
);

// Positive-edge triggered D flip-flop with asynchronous reset
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q = 1'b0;   // async reset with blocking assignment
    end else begin
        q = d;      // clocked assignment with blocking assignment
    end
end

endmodule