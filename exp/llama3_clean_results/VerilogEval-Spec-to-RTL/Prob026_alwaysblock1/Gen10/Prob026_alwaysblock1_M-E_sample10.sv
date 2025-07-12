module TopModule #(
    parameter LOGIC_OP = 0 // 0: AND, 1: OR, 2: XOR
)(
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

assign out_assign = (LOGIC_OP == 0)? (a & b) : 
                    (LOGIC_OP == 1)? (a | b) : 
                    (LOGIC_OP == 2)? (a ^ b) : 1'b0;

always @(*) begin
    case (LOGIC_OP)
        0: out_alwaysblock = a & b; // AND
        1: out_alwaysblock = a | b; // OR
        2: out_alwaysblock = a ^ b; // XOR
        default: out_alwaysblock = 1'b0;
    endcase
end

endmodule

module testbench;
    reg a, b;
    wire out_assign;
    reg out_alwaysblock;

    TopModule u_top_module(
       .a(a),
       .b(b),
       .out_assign(out_assign),
       .out_alwaysblock(out_alwaysblock)
    );

    initial begin
        a = 1'b0; b = 1'b0;
        #10;
        a = 1'b0; b = 1'b1;
        #10;
        a = 1'b1; b = 1'b0;
        #10;
        a = 1'b1; b = 1'b1;
        #10;
        $finish;
    end
endmodule