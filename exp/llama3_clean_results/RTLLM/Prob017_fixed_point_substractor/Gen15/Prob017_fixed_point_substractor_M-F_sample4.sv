module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Perform subtraction directly, relying on Verilog's handling of signed numbers
always @(*) begin
    c = a - b;
end

endmodule

// Example instantiation in a testbench, ensuring correct parameter access
module testbench;
    parameter Q = 8;
    parameter N = 16;

    reg signed [N-1:0] a, b;
    wire signed [N-1:0] c;

    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    initial begin
        // Initialize inputs
        a = 10;
        b = 5;
        
        // Wait and observe output
        #10;
        $display("Result: %d", c);
    end
endmodule