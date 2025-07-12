// Define a module for the 3-input AND logic
module and3_logic(input a, input b, input c, input d, input e, input f, output y);
    assign y = (a & b & c) | (d & e & f);
endmodule

// Define a module for the 2-input AND logic
module and2_logic(input a, input b, input c, input d, output y);
    assign y = (a & b) | (c & d);
endmodule

// Define the TopModule
module TopModule(
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p1e,
    input p1f,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

    // Instantiate logic for p1y and p2y
    and3_logic and3_inst(p1a, p1b, p1c, p1d, p1e, p1f, p1y);
    and2_logic and2_inst(p2a, p2b, p2c, p2d, p2y);

endmodule