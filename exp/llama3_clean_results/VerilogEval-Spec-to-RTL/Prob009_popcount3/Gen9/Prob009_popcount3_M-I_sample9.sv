module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Improved implementation using bitwise operations
    wire [2:0] count;
    assign count[0] = in[0];
    assign count[1] = in[1];
    assign count[2] = in[2];

    // Use a simple counter to accumulate the count
    assign out = {1'b0, count[0]} + {1'b0, count[1]} + {1'b0, count[2]};

    // Alternative implementation using a Kogge-Stone adder or similar efficient adder architecture
    // can be explored, but given the small input size, the benefit might be limited.

endmodule