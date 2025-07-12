module TopModule(
    output out
);
    // Refactored version using an always block, though less conventional for this purpose.
    always @(*) begin
        out = 1'b0;
    end

endmodule