module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Count '1's in lower 2 bits
    wire [1:0] lower_count = {1'b0, in[0]} + {1'b0, in[1]};
    
    // Add MSB to the lower count
    assign out = lower_count + {1'b0, in[2]};

endmodule