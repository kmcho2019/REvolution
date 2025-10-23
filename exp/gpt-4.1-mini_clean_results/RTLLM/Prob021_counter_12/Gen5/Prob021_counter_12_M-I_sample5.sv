module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

always @(posedge clk) begin
    if (!rst_n)
        out <= 4'd0;                       // Synchronous active-low reset
    else if (valid_count) begin
        if (out == 4'd11)
            out <= 4'd0;                  // Wrap around to 0 after 11
        else
            out <= out + 1'b1;            // Increment count
    end
    // else hold the current value by not assigning out (implicit)
end

endmodule