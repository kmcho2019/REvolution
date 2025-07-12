module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (!j && !k) begin
        // Q remains the same as Qold
        Q <= Q;
    end else if (!j && k) begin
        // Q becomes 0
        Q <= 1'b0;
    end else if (j && !k) begin
        // Q becomes 1
        Q <= 1'b1;
    end else if (j && k) begin
        // Q becomes the opposite of Qold
        Q <= ~Q;
    end
end

endmodule