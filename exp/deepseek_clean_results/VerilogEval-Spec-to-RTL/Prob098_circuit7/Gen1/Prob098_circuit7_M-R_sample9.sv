module TopModule (
    input clk,
    input a,
    output reg q
);

wire next_q;

// Combinational next-state logic
assign next_q = ~a;

// Sequential element
always @(posedge clk) begin
    q <= next_q;
end

endmodule