module TopModule(
    input [3:0] x,  // 4-bit input
    output f        // 1-bit output
);

always @(*) begin
    if (x[3] && (x[1] || x[2])) begin
        f = 1'b1;
    end else if (!x[3] && !x[1] && x[2] && x[0]) begin
        f = 1'b1;
    end else if (!x[3] && x[1] && x[2]) begin
        f = 1'b1;
    end else begin
        f = 1'b0;
    end
end

endmodule