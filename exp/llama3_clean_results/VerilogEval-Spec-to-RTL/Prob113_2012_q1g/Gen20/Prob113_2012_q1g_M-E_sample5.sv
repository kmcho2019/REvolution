module TopModule(
    input [3:0] x,
    output f
);

    reg [1:0] mode;
    assign mode = {x[2], x[3]};

    always @(x) begin
        case (mode)
            2'b00: f = (~x[0] & ~x[1]) | (x[0] & ~x[1]);
            2'b01: f = 1'b0;
            2'b10: f = (~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & ~x[1]);
            2'b11: f = ~(x[0] & ~x[1]);
        endcase
    end

endmodule