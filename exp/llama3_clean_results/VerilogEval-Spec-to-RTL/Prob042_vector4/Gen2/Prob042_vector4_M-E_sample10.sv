module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    reg [31:0] sign_extension;
    
    always @(*) begin
        if (in[7] == 1'b1) begin
            sign_extension = {24{1'b1}};
        end else begin
            sign_extension = {24{1'b0}};
        end
        out = {sign_extension, in};
    end
endmodule