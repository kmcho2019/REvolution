module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    always @(*) begin
        if (a <= b) begin
            if (a <= c) begin
                if (a <= d) begin
                    min = a;
                end else begin
                    min = d;
                end
            end else if (c <= d) begin
                min = c;
            end else begin
                min = d;
            end
        end else if (b <= c) begin
            if (b <= d) begin
                min = b;
            end else begin
                min = d;
            end
        end else if (c <= d) begin
            min = c;
            end else begin
                min = d;
            end
    end

endmodule