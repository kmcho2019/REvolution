module TopModule(
    output out
);
    reg [0:0] output_reg; // Initialize with a width of 1 bit

    initial output_reg = 1'b0; // Initialize output_reg to 0

    always @(*) begin
        out = output_reg;
    end
endmodule