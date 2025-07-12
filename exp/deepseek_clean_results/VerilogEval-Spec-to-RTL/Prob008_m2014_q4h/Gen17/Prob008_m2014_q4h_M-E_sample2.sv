module TopModule (
    input in,
    output out
);
    // Transmission gate style implementation
    // with hardwired enable to maintain combinational behavior
    bufif1 my_buf(out, in, 1'b1);  // Enabled buffer
endmodule