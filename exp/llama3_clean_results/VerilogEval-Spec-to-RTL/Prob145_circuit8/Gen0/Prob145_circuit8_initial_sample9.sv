module TopModule(
    input clock,
    input a,
    output p,
    output reg q
);

always @(posedge clock) begin
    if (a == 1'b1) begin
        q <= 1'b1;
    end
end

always @(*) begin
    if (clock == 1'b1 && a == 1'b1) begin
        p = 1'b1;
    end else begin
        p = 1'b0;
    end
end

always @(negedge clock) begin
    if (a == 1'b1) begin
        q <= 1'b0;
    end
end

endmodule