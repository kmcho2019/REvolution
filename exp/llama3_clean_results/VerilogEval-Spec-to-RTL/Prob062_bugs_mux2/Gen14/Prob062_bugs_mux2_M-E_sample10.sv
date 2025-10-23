module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    integer i;
    always @(a, b, sel) begin
        for (i = 0; i < 8; i++) begin
            if (sel) begin
                out[i] = b[i];
            end else begin
                out[i] = a[i];
            end
        end
    end

endmodule