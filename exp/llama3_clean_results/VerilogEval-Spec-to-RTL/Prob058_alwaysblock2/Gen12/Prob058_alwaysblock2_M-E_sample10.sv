// Parameterizable module for XOR operation
module xor_operation(
    parameter MODE = "CONTINUOUS",
    input  clk,
    input  a,
    input  b,
    output out
);
    wire internal_out;

    // Continuous assignment
    assign internal_out = a ^ b;

    // Combinational always block
    always_comb begin
        out = internal_out;
    end

    // Clocked always block
    always_ff @(posedge clk) begin
        if (MODE == "CLOCKED") begin
            out <= internal_out;
        end
    end

    // Default out value for non-clocked modes
    always_comb begin
        if (MODE != "CLOCKED") begin
            out = internal_out;
        end
    end
endmodule

// TopModule instantiating the parameterizable module
module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);
    xor_operation #(.MODE("CONTINUOUS")) u_assign(
        .clk(clk),
        .a(a),
        .b(b),
        .out(out_assign)
    );

    xor_operation #(.MODE("COMBINATIONAL")) u_always_comb(
        .clk(clk),
        .a(a),
        .b(b),
        .out(out_always_comb)
    );

    xor_operation #(.MODE("CLOCKED")) u_always_ff(
        .clk(clk),
        .a(a),
        .b(b),
        .out(out_always_ff)
    );
endmodule