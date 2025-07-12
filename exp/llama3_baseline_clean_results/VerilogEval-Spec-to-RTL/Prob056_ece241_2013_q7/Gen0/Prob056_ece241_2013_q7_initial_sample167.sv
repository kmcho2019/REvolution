module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 1'b0 && k == 1'b0) begin
        // Q remains the same
    end else if (j == 1'b0 && k == 1'b1) begin
        // Q becomes 0
        Q <= 1'b0;
    end else if (j == 1'b1 && k == 1'b0) begin
        // Q becomes 1
        Q <= 1'b1;
    end else if (j == 1'b1 && k == 1'b1) begin
        // Q becomes ~Qold
        Q <= ~Q;
    end
end

endmodule