module TopModule(output reg zero);
    // Procedurally driven constant zero output
    always @(*) begin
        zero = 1'b0;
    end
endmodule