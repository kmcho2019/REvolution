module TopModule (
    output out
);
    assign out = 1'b0;
    
    // Formal verification assertion
    // synthesis translate_off
    always @(*) begin
        assert(out === 1'b0) else $error("Output must always be 0");
    end
    // synthesis translate_on
endmodule