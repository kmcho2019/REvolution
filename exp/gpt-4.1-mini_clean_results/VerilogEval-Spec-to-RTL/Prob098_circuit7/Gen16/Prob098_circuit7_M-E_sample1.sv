module TopModule (
    input clk,
    input a,
    output q
);
    reg stored_bit;

    // Store 'a' on rising clock edge directly
    always @(posedge clk) begin
        stored_bit <= a;
    end

    // Output is inversion of stored bit
    assign q = ~stored_bit;

endmodule