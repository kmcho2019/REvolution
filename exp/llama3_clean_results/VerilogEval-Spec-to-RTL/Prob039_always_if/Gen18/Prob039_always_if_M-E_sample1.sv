// Define a module for the 2-to-1 multiplexer
module TopModule #(
    parameter WIDTH = 1
)(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input             sel_b1,
    input             sel_b2,
    output logic [WIDTH-1:0] out_assign,
    output logic [WIDTH-1:0] out_always
);

always @(*) begin
    case ({sel_b1, sel_b2})
        2'b11: begin
            out_assign = b;
            out_always = b;
        end
        default: begin
            out_assign = a;
            out_always = a;
        end
    endcase
end

endmodule

// Define a testbench for the TopModule
module TopModule_tb;
    reg [1-1:0] a;
    reg [1-1:0] b;
    reg         sel_b1;
    reg         sel_b2;
    wire        out_assign;
    wire        out_always;

    TopModule top_module (
        .a(a),
        .b(b),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .out_assign(out_assign),
        .out_always(out_always)
    );

    initial begin
        $dumpfile("TopModule_tb.vcd");
        $dumpvars;

        // Test cases
        a = 0; b = 1; sel_b1 = 0; sel_b2 = 0; #10;
        $display("out_assign = %b, out_always = %b", out_assign, out_always);

        a = 0; b = 1; sel_b1 = 1; sel_b2 = 0; #10;
        $display("out_assign = %b, out_always = %b", out_assign, out_always);

        a = 0; b = 1; sel_b1 = 0; sel_b2 = 1; #10;
        $display("out_assign = %b, out_always = %b", out_assign, out_always);

        a = 0; b = 1; sel_b1 = 1; sel_b2 = 1; #10;
        $display("out_assign = %b, out_always = %b", out_assign, out_always);

        $finish;
    end
endmodule