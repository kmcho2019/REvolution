module TopModule(
    input  [3:0] x,
    output reg f
);

always @(*) begin
    if (x[3] && x[0]) begin
        f = 1;
    end else if (x[1] && ~x[2]) begin
        f = 0;
    end else if (~x[1] && x[2]) begin
        f = 1;
    end else if (x[1] && x[2]) begin
        f = 1;
    end else begin
        f = 0;
    end
end

endmodule