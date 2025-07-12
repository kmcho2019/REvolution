module TopModule(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

    reg [3:0] sel;
    always @(*) begin
        case (c)
            4'd0: sel = 4'd1;
            4'd1: sel = 4'd2;
            4'd2: sel = 4'd4;
            4'd3: sel = 4'd8;
            default: sel = 4'd15;
        endcase
    end

    always @(*) begin
        if (sel == 4'd1) q = b;
        else if (sel == 4'd2) q = e;
        else if (sel == 4'd4) q = a;
        else if (sel == 4'd8) q = d;
        else q = 4'd15;
    end

endmodule