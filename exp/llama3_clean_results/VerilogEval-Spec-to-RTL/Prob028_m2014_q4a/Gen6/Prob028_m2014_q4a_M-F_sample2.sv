module TopModule(
    input  d,
    input  ena,
    output reg q
);
always @(posedge ena or negedge ena) begin
    if (ena) begin
        q <= d; // Use non-blocking assignment
    end
end

endmodule