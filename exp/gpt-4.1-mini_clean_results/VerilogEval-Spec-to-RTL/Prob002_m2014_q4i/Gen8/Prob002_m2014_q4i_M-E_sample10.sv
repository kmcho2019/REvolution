module TopModule(output out);
    wire zero_input = 1'b0;
    wire internal_signal = 1'b1; // can be any value

    assign out = zero_input & internal_signal;
endmodule