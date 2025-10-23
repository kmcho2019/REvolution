module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge ar or posedge clk) begin
    if (ar) begin
        q <= 1'b0;
    end else if (clk) begin
        // This condition will be true only at the posedge of clk when ar is not asserted
        q <= d;
    end
end

endmodule