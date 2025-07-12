module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    case (r)
        1'b1: q <= 1'b0; // Reset 'q' to 0 when 'r' is high
        1'b0: q <= d;    // Load 'd' into 'q' when 'r' is low
    endcase
end

endmodule