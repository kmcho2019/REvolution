module TopModule(
    input  [3:0] x,
    output       f
);

    always @(*) begin
        if (x[3] && !x[2] && !x[1]) begin
            f = 1;
        end else if (!x[3] && x[2] && x[1]) begin
            f = 1;
        end else if (x[3] && x[2] && x[1] && !x[0]) begin
            f = 1;
        end else if (x[3] && x[2] && !x[1] && x[0]) begin
            f = 1;
        end else begin
            f = 0;
        end
    end

endmodule