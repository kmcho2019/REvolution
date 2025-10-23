module TopModule(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

    reg [3:0] one_hot;
    always @(*) begin
        case (c[1:0])
            2'd0: one_hot = 4'b0001;
            2'd1: one_hot = 4'b0010;
            2'd2: one_hot = 4'b0100;
            2'd3: one_hot = 4'b1000;
            default: one_hot = 4'b0000;
        endcase
    end

    always @(*) begin
        q = (one_hot[0] == 1'b1) ? b :
            (one_hot[1] == 1'b1) ? e :
            (one_hot[2] == 1'b1) ? a :
            (one_hot[3] == 1'b1) ? d : 4'd15;
    end

endmodule