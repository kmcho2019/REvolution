module TopModule(
    output wire out
);
    // Drive output permanently low with minimal logic
    assign out = 1'b0;
endmodule