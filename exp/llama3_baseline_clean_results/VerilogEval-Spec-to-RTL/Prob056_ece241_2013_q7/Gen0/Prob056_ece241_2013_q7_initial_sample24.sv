module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 1'b0 && k == 1'b0) begin
        Q <= Q; // Q remains the same
    end else if (j == 1'b0 && k == 1'b1) begin
        Q <= 1'b0; // Q becomes 0
    end else if (j == 1'b1 && k == 1'b0) begin
        Q <= 1'b1; // Q becomes 1
    end else if (j == 1'b1 && k == 1'b1) begin
        Q <= ~Q; // Q becomes ~Qold
    end
end

endmodule