// Define a module for the XOR operation
module XorModule(
    input a,
    input b,
    output z
);
    assign z = a ^ b; // Continuous assignment for combinational logic
endmodule

// Define a module for the D flip-flop
module DffModule(
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d; // Update q with input d at positive edge of clk
    end
endmodule

// TopModule that instantiates XorModule and DffModule
module TopModule(
    input clk,
    input in,
    output reg out
);
    wire xor_out; // Wire to connect XorModule output to DffModule input

    // Instantiate XorModule
    XorModule xor_instance(
        .a(in),
        .b(out),
        .z(xor_out)
    );

    // Instantiate DffModule
    DffModule dff_instance(
        .clk(clk),
        .d(xor_out),
        .q(out)
    );
endmodule