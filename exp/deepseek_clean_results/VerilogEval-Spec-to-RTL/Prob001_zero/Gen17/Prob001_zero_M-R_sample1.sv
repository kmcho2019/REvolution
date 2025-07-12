module TopModule (
    output zero
);
    // Alternative implementation with same PPA characteristics
    wire constant_low = 1'b0;
    assign zero = constant_low;
endmodule