module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (~j && ~k) begin
        // No change, Q remains Qold
    end else if (~j && k) begin
        Q <= 0;
    end else if (j && ~k) begin
        Q <= 1;
    end else if (j && k) begin
        Q <= ~Q; // ~Qold
    end
end

endmodule