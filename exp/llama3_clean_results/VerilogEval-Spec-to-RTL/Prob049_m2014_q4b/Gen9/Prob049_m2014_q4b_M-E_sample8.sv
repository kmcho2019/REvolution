module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

// Reset Logic Block
always @(posedge ar) begin
    q <= 1'b0;
end

// Clocked Logic Block
always @(posedge clk) begin
    if (!ar) begin
        q <= d;
    end
end

endmodule