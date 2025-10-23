module TopModule (
    input [2:0] in,
    output reg [1:0] out
);
    wire [1:0] sum;
    assign sum = in[0] + in[1] + in[2];

    always @(*) begin
        case (sum)
            2'd0: out = 2'b00;
            2'd1: out = 2'b01;
            2'd2: out = 2'b10;
            2'd3: out = 2'b11;
            default: out = 2'b00;
        endcase
    end
endmodule