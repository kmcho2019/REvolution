module TopModule (
    input [7:0] in,
    output [31:0] out
);

    reg [31:0] out_reg;

    always @(*) begin
        if (in[7] == 1'b1) begin
            // Sign extend for negative numbers
            out_reg = ({24{1'b1}} >> 24) | (in << 24);
        end else begin
            // Zero extend for positive numbers
            out_reg = in << 24;
        end
    end

    assign out = out_reg;

endmodule