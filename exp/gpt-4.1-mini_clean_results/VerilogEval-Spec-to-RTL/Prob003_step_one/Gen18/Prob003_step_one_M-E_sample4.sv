module ConstHigh(output logic out);
    // This module continuously drives a logic high
    assign out = 1'b1;
endmodule

module TopModule(output one);
    // Instantiate ConstHigh to drive the output 'one'
    ConstHigh ch(.out(one));
endmodule