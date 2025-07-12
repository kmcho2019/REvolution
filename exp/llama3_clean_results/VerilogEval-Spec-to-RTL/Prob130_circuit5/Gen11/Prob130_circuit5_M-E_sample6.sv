module TopModule(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

    always @(*) begin
        if (c < 4'd4) begin
            case (c)
                4'd0: q = b;
                4'd1: q = e;
                4'd2: q = a;
                4'd3: q = d;
            endcase
        end else begin
            q = 4'd15;
        end
    end

    // Alternative implementation using a LUT
    // reg [3:0] lut_out;
    // always @(*) begin
    //     case (c)
    //         4'd0: lut_out = b;
    //         4'd1: lut_out = e;
    //         4'd2: lut_out = a;
    //         4'd3: lut_out = d;
    //         default: lut_out = 4'd15;
    //     endcase
    //     q = lut_out;
    // end

endmodule