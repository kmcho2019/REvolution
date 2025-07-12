module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg detect;

always @(posedge clock) begin
    if (a &&!detect) begin
        detect <= 1'b1;
    end else if (!a) begin
        detect <= 1'b0;
    end
end

always @(negedge clock) begin
    if (detect) begin
        p <= 1'b1;
    end else begin
        p <= 1'b0;
    end
end

always @(negedge clock) begin
    if (p &&!a) begin
        q <= 1'b1;
    end else if (a) begin
        q <= 1'b0;
    end
end

endmodule