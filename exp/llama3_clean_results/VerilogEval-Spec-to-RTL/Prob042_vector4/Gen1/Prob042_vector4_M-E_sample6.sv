module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    reg [31:0] temp;

    always @(in) begin
        if (in[7] == 1'b1) begin
            temp = {24'd-1, in};
        end else begin
            temp = {24'd0, in};
        end
    end

    assign out = temp;

endmodule