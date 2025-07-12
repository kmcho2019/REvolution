module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

wire lower_nibble_active = |in[3:0];
wire [2:0] lower_pos;

always @(*) begin
    // Lower nibble processing
    if (in[0])      lower_pos = 3'd0;
    else if (in[1]) lower_pos = 3'd1;
    else if (in[2]) lower_pos = 3'd2;
    else if (in[3]) lower_pos = 3'd3;
    else            lower_pos = 3'd0;

    // Upper nibble processing (only if lower nibble is inactive)
    if (!lower_nibble_active) begin
        if (in[4])      pos = 3'd4;
        else if (in[5]) pos = 3'd5;
        else if (in[6]) pos = 3'd6;
        else if (in[7]) pos = 3'd7;
        else            pos = 3'd0;
    end else begin
        pos = lower_pos;
    end

    // Handle all-zero case
    if (!(|in)) pos = 3'd0;
end

endmodule