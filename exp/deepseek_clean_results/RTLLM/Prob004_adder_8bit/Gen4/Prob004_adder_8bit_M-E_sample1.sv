module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower 4-bit adder with carry prediction
    wire [3:0] sum_low;
    wire cout_low_predicted;
    wire cout_low_actual;
    
    // Carry prediction: if any bit pair will generate carry
    assign cout_low_predicted = (a[0] & b[0]) | 
                               (a[1] & b[1]) | 
                               (a[2] & b[2]) | 
                               (a[3] & b[3]);
    
    // Actual lower 4-bit addition
    assign {cout_low_actual, sum_low[3:0]} = a[3:0] + b[3:0] + cin;
    
    // Upper 4-bit carry-select adders
    wire [3:0] sum_high_0, sum_high_1;
    wire cout_high_0, cout_high_1;
    
    // Upper bits assuming carry-in 0
    assign {cout_high_0, sum_high_0} = a[7:4] + b[7:4] + 1'b0;
    
    // Upper bits assuming carry-in 1
    assign {cout_high_1, sum_high_1} = a[7:4] + b[7:4] + 1'b1;
    
    // Final output selection based on actual carry from lower bits
    assign sum = {cout_low_actual ? sum_high_1 : sum_high_0, sum_low};
    assign cout = cout_low_actual ? cout_high_1 : cout_high_0;
    
endmodule