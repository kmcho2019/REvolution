module TopModule(
    input  [3:0] x,
    output       f
);

    always @(x) begin
        if ((x[2] && x[3]) && ((~x[0] && ~x[1]) || (~x[0] && x[1]) || (x[0] && x[1]))) begin
            f = 1'b1;
        end else if ((~x[2] && ~x[3]) && ((~x[0] && ~x[1]) || (x[0] && ~x[1]))) begin
            f = 1'b1;
        end else if ((x[2] && ~x[3]) && ((~x[0] && ~x[1]) || (~x[0] && x[1]) || (x[0] && ~x[1]))) begin
            f = 1'b1;
        end else begin
            f = 1'b0;
        end
    end

endmodule