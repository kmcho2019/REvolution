module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

reg toggle;

// Toggle flip-flop to detect both clock edges
always @(posedge clk or posedge ar) begin
    if (ar) toggle <= 1'b0;
    else    toggle <= ~toggle;
end

// Main data capture on both edges
always @(posedge toggle or posedge ar) begin
    if (ar) q <= 1'b0;
    else    q <= d;
end

endmodule