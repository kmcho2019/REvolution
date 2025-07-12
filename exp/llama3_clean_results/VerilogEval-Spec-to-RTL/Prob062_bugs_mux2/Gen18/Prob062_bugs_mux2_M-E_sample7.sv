module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    always_comb begin
        if (sel == 1'b0) begin
            out = a;
        end else begin
            out = b;
        end
    end

endmodule