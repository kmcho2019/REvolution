module RecursiveAdder(
    input   [3:0] a,
    input   [3:0] b,
    output  [4:0] sum
);

    function [4:0] recursive_add;
        input [3:0] a;
        input [3:0] b;
        input [3:0] idx;
        reg [3:0] idx_reg;
        begin
            idx_reg = idx;
            if (idx_reg == 4'd0) begin
                recursive_add = {1'b0, a[0] ^ b[0]};
            end else begin
                recursive_add = {recursive_add(a, b, idx_reg - 1)[4] ^ (a[idx_reg - 1] ^ b[idx_reg - 1]), recursive_add(a, b, idx_reg - 1)[3:0]};
            end
        end
    endfunction

    assign sum = recursive_add(a, b, 4'd3);

endmodule

module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    RecursiveAdder ra(
       .a(x),
       .b(y),
       .sum(sum)
    );

endmodule