module TopModule(output reg zero);
    // Asynchronously reset zero to 0 and never set it
    always @(*) begin
        zero = 1'b0;
    end
endmodule