module TopModule (
    input [7:0] in,
    output reg [31:0] out
);

    always @(*) begin
        case (in[7])
            1'b1: out = {24{1'b1}, in};
            1'b0: out = {24{1'b0}, in};
            default: out = 32'd0; // Default case for handling unknown values
        endcase
    end

endmodule