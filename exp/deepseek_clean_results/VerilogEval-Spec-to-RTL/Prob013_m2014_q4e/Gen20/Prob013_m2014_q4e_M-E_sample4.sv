module TopModule (
    input in1,
    input in2,
    output out
);
    // Pull-up network (active when both inputs are 0)
    wire pullup_en = ~in1 & ~in2;
    // Pull-down network (active when either input is 1)
    wire pulldown_en = in1 | in2;
    
    // Tri-state buffers for pull-up and pull-down
    assign out = pullup_en ? 1'b1 : 1'bz;
    assign out = pulldown_en ? 1'b0 : 1'bz;
endmodule