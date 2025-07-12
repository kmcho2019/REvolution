module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= #0 0; // Immediate reset, but add a small delay for simulation clarity
    end else if (posedge clk) begin
        q <= #0 d; // Capture 'd' on the positive edge of 'clk'
    end
end

endmodule