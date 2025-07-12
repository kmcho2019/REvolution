module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 0 && k == 0) begin
        // Q remains the same (Qold)
        Q <= Q;
    end else if (j == 0 && k == 1) begin
        // Q becomes 0
        Q <= 0;
    end else if (j == 1 && k == 0) begin
        // Q becomes 1
        Q <= 1;
    end else if (j == 1 && k == 1) begin
        // Q becomes the inverse of Qold (~Qold)
        Q <= ~Q;
    end
end

endmodule