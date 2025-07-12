module TopModule(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q = d; // Blocking assignment is not recommended in sequential logic, but for a simple D flip-flop, it could be considered for its simplicity. However, non-blocking is preferred for sequential logic.
end

endmodule