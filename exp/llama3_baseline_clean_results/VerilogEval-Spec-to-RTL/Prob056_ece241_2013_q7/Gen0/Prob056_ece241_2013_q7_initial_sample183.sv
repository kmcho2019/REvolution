module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (~j & ~k) begin
        Q <= Q; // Q remains Qold
    end else if (~j & k) begin
        Q <= 1'b0; // Q becomes 0
    end else if (j & ~k) begin
        Q <= 1'b1; // Q becomes 1
    end else begin
        Q <= ~Q; // Q becomes ~Qold
    end
end

endmodule