module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    reg [3:0] out_reg;

    always @(*)
    begin
        case (sel)
            256'd0: out_reg = in[3:0];
            256'd1: out_reg = in[7:4];
            256'd2: out_reg = in[11:8];
            // ...
            // Adding cases for all 256 possible values of sel
            // ...
            256'd255: out_reg = in[1019:1016];
            default: out_reg = 4'b0; // Optional default case
        endcase
    end

    assign out = out_reg;

endmodule