module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    always @(*) begin
        pos = 3'd0;
        if (in != 8'd0) begin
            pos = $clog2(in);
        end
    end

endmodule