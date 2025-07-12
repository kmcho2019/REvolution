module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct selection using case statement
    always @(*) begin
        case (sel)
            8'd0: out = in[0];
            8'd1: out = in[1];
            8'd2: out = in[2];
            // ... (cases 3 through 253)
            8'd254: out = in[254];
            8'd255: out = in[255];
            default: out = 1'b0;
        endcase
    end

endmodule