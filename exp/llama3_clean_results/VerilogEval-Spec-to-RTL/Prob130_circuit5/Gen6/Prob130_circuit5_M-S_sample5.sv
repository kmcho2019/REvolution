module TopModule(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

    always @(*) begin
        if (c > 4'd3) begin
            q = 4'd15; // Assigning 'f' as per the original implementation
        end else begin
            case (c)
                4'd0: q = b;
                4'd1: q = e;
                4'd2: q = a;
                4'd3: q = d;
            endcase
        end
    end

endmodule