module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    reg [99:0] shift_reg;

    always @(posedge in) begin
        shift_reg[99] <= in[0];
        for (int i = 1; i < 100; i++) begin
            shift_reg[i-1] <= in[i];
        end
    end

    always @(*) begin
        for (int i = 0; i < 100; i++) begin
            out[i] = shift_reg[99-i];
        end
    end

endmodule