module TopModule(
    input  d,
    input  ena,
    output reg q
);
always @(posedge ena or d) begin
    if (ena) begin
        q <= d; // Non-blocking assignment for sequential update
    end
end

endmodule