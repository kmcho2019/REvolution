module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    reg [31:0] shift_reg;
    integer i;

    always @(*) begin
        // Initialize with padding bits
        shift_reg = 32'b0;
        shift_reg[1:0] = 2'b11;
        
        // Shift in all input bits starting from MSB
        for (i = 29; i >= 0; i = i - 1) begin
            shift_reg = {shift_reg[30:0], shift_reg[31]};
            case (i)
                29: shift_reg[31] = a[4];
                24: shift_reg[31] = b[4];
                19: shift_reg[31] = c[4];
                14: shift_reg[31] = d[4];
                9:  shift_reg[31] = e[4];
                4:  shift_reg[31] = f[4];
                default: shift_reg[31] = shift_reg[31];
            endcase
        end
    end

    // Assign outputs from the shift register
    assign w = shift_reg[31:24];
    assign x = shift_reg[23:16];
    assign y = shift_reg[15:8];
    assign z = shift_reg[7:0];

endmodule