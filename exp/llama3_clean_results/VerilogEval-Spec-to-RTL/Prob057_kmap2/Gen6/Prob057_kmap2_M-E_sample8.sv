module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

reg [3:0] decoder_out;

always @(*)
begin
    // Section 1: ab = 00
    if (!a && !b) begin
        if (!c && !d) decoder_out = 4'b1000;
        else if (!c && d) decoder_out = 4'b0100;
        else if (c && !d) decoder_out = 4'b0010;
        else if (c && d) decoder_out = 4'b0001;
    end
    // Section 2: ab = 01
    else if (!a && b) begin
        if (!c && !d) decoder_out = 4'b1000;
        else if (!c && d) decoder_out = 4'b0000;
        else if (c && !d) decoder_out = 4'b0000;
        else if (c && d) decoder_out = 4'b0100;
    end
    // Section 3: ab = 11
    else if (a && b) begin
        if (!c && !d) decoder_out = 4'b0000;
        else if (!c && d) decoder_out = 4'b0000;
        else if (c && !d) decoder_out = 4'b0010;
        else if (c && d) decoder_out = 4'b1000;
    end
    // Section 4: ab = 10
    else if (a && !b) begin
        if (!c && !d) decoder_out = 4'b1000;
        else if (!c && d) decoder_out = 4'b0000;
        else if (c && !d) decoder_out = 4'b0001;
        else if (c && d) decoder_out = 4'b0000;
    end

    out = decoder_out[0] || decoder_out[1] || decoder_out[2] || decoder_out[3];
end

endmodule