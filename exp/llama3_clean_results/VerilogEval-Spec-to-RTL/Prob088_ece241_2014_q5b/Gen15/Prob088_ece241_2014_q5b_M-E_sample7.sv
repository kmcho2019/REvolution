module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg seen_one; // Flip-flop to remember if a '1' has been seen on input 'x'

always @(posedge clk or posedge areset) begin
    if(areset) begin
        seen_one <= 1'b0; // Reset to state A (not seen a '1')
    end else begin
        if(x) begin
            seen_one <= 1'b1; // If 'x' is '1', move to state B (seen a '1')
        end
    end
end

always @(*) begin
    if(seen_one) begin
        z = ~x; // If in state B (seen a '1'), 'z' is the complement of 'x'
    end else begin
        z = x; // If in state A (not seen a '1'), 'z' is the same as 'x'
    end
end

endmodule