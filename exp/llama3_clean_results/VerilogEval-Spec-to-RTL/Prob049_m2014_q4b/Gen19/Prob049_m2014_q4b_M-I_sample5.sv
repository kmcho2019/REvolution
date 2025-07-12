module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge ar or posedge clk) begin
    if (ar) begin
        q = 1'b0; // Immediate reset
    end else begin
        q <= d; // Non-blocking assignment for clock edge
    end
end

endmodule