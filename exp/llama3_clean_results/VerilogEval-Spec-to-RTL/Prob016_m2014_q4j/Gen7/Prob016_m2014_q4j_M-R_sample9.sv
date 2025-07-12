// Refactored TopModule using Verilog's arithmetic operators
module TopModule(
    input   logic [3:0] x,
    input   logic [3:0] y,
    output  logic [4:0] sum
);

    // Perform the addition directly and handle the overflow
    assign sum = {1'b0, x} + {1'b0, y};

    // Alternatively, to explicitly handle the carry bit
    // logic [4:0] temp_sum;
    // assign temp_sum = x + y;
    // assign sum = {temp_sum[4], temp_sum[3:0]};

endmodule