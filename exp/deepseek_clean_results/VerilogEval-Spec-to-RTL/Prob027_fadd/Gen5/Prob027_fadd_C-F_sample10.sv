module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Single assignment combining both outputs
    // Explicitly shows sum as LSB and cout as MSB of the addition result
    assign {cout, sum} = {1'b0, a} + {1'b0, b} + {1'b0, cin};
endmodule