module TopModule #(
    parameter IMPLEMENTATION = "ASSIGN"
) (
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

generate
    if (IMPLEMENTATION == "ASSIGN") begin
        assign out_assign = a & b;
        assign out_alwaysblock = a & b;
    end else if (IMPLEMENTATION == "ALWAYS") begin
        assign out_assign = a & b;
        always @(*) begin
            out_alwaysblock = a & b;
        end
    end else begin
        $display("Error: Invalid IMPLEMENTATION parameter");
        $finish;
    end
endgenerate

endmodule

module testbench;
    reg a, b;
    wire out_assign, out_alwaysblock;

    TopModule #(.IMPLEMENTATION("ASSIGN")) u_top_module_assign (
       .a(a),
       .b(b),
       .out_assign(out_assign),
       .out_alwaysblock(out_alwaysblock)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
        a = 0; b = 0;
        #10;
        a = 0; b = 1;
        #10;
        a = 1; b = 0;
        #10;
        a = 1; b = 1;
        #10;
        $finish;
    end
endmodule