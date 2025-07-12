module TopModule(
    output reg zero
);

    initial begin
        zero = 1'b0;
    end

    always @(*) begin
        zero = zero; // Holds the current value (zero) without change
    end

endmodule