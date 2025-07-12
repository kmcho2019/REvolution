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

// TopModule that integrates XOR operation and instantiates DffModule
module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out with a default value
);
    wire xor_out; // Wire to connect XOR output to DffModule input

    // Perform XOR operation directly within TopModule
    assign xor_out = in ^ out;

    // Instantiate DffModule
    DffModule dff_instance(
       .clk(clk),
       .d(xor_out),
       .q(out)
    );
endmodule