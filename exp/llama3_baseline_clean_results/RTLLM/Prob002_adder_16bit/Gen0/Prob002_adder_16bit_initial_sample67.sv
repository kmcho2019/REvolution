// Define the 8-bit full adder module
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a, b;
    input Cin;
    output [7:0] y;
    output Co;
    
    wire [8:0] sum;
    
    // Calculate the sum and carry using built-in operators
    assign sum = {1'b0, a} + {1'b0, b} + {8{Cin}};
    assign y = sum[7:0];
    assign Co = sum[8];
endmodule

// Define the 16-bit full adder module
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;
    
    // Internal wires for connecting 8-bit adders
    wire [7:0] low_sum, high_sum;
    wire low_Co;
    
    // Instantiate two 8-bit adders
    adder_8bit low_adder(
        .a(a[7:0]), 
        .b(b[7:0]), 
        .Cin(Cin), 
        .y(low_sum), 
        .Co(low_Co)
    );
    
    adder_8bit high_adder(
        .a(a[15:8]), 
        .b(b[15:8]), 
        .Cin(low_Co), 
        .y(high_sum), 
        .Co(Co)
    );
    
    // Combine the sums from both adders
    assign y = {high_sum, low_sum};
endmodule