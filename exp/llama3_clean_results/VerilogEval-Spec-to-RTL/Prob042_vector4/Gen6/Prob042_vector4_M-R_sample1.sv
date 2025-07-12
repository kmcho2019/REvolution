module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    logic [31:0] sign_extended;

    always @(*) begin
        if (in[7] == 1'b1) begin
            // If the sign bit is 1, extend with ones
            sign_extended = {24{1'b1}, in};
        end else begin
            // If the sign bit is 0, extend with zeros
            sign_extended = {24{1'b0}, in};
        end
    end

    assign out = sign_extended;
endmodule