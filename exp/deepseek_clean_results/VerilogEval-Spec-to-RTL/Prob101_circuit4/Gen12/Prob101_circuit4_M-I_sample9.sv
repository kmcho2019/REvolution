module TopModule (
    input a,    // unused
    input b,
    input c,
    input d,    // unused
    output q
);

    assign q = b | c;
    // synthesis translate_off
    initial begin
        $display("Note: Inputs a and d are unused in this module");
    end
    // synthesis translate_on

endmodule