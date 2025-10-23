module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // carry = 0: before first '1' encountered, output x as is
    // carry = 1: after first '1' encountered, invert x
    reg carry;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            carry <= 1'b0;
            z <= 1'b0;
        end else begin
            // Update carry flag: set when first '1' bit encountered
            if (!carry && x)
                carry <= 1'b1;
            // Output depends on carry and current input
            if (!carry)
                z <= x;
            else
                z <= ~x;
        end
    end

endmodule