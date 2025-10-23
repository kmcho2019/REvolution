module TopModule(
    input  d,
    input  ena,
    output reg q
);
// The always block is sensitive to the 'ena' signal, allowing it to capture 
// the 'd' value when 'ena' is high and retain 'q' when 'ena' is low.
always @(ena or d) begin
    if (ena) begin
        q <= d; // Non-blocking assignment to update 'q' when 'ena' is high.
    end else begin
        // When 'ena' is low, 'q' retains its value, which is the behavior of a latch.
    end
end

endmodule