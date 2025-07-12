module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output reg overflow
);

    wire [8:0] temp;

    assign temp = {1'b0, a} + {1'b0, b};
    assign s = temp[7:0];
    always @(*) begin
        if (a[7] == b[7] && a[7] != temp[8]) begin
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end
    end

endmodule