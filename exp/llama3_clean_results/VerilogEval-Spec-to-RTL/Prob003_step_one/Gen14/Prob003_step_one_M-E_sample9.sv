module TopModule (
    output one
);
    wire internal_signal;
    assign internal_signal = 1'b1;
    bufif1 buf_instance (.A(internal_signal), .Y(one));
endmodule