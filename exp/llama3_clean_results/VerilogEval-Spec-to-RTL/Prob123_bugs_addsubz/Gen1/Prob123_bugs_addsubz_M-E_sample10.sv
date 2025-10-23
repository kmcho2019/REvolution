module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] alu_out;
    wire zero_detect;

    // Arithmetic Logic Unit (ALU)
    always @(*) begin
        if (do_sub) begin
            alu_out = a - b;
        end else begin
            alu_out = a + b;
        end
    end

    // Zero Detection Logic
    assign zero_detect = (alu_out == 8'b0);

    // Output Assignment
    always @(*) begin
        out = alu_out;
        result_is_zero = zero_detect;
    end

endmodule