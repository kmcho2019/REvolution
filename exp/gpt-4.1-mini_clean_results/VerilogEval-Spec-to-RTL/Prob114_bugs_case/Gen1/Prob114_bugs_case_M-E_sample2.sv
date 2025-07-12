module TopModule (
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

wire [9:0] matches;
assign matches[0] = (code == 8'h45); // 0
assign matches[1] = (code == 8'h16); // 1
assign matches[2] = (code == 8'h1e); // 2
assign matches[3] = (code == 8'h26); // 3
assign matches[4] = (code == 8'h25); // 4
assign matches[5] = (code == 8'h2e); // 5
assign matches[6] = (code == 8'h36); // 6
assign matches[7] = (code == 8'h3d); // 7
assign matches[8] = (code == 8'h3e); // 8
assign matches[9] = (code == 8'h46); // 9

always @(*) begin
    valid = |matches;
    if (valid) begin
        // Encode which key matched by checking matches bits
        // Since only one should match, simple priority encode
        if      (matches[0]) out = 4'd0;
        else if (matches[1]) out = 4'd1;
        else if (matches[2]) out = 4'd2;
        else if (matches[3]) out = 4'd3;
        else if (matches[4]) out = 4'd4;
        else if (matches[5]) out = 4'd5;
        else if (matches[6]) out = 4'd6;
        else if (matches[7]) out = 4'd7;
        else if (matches[8]) out = 4'd8;
        else /*matches[9]*/   out = 4'd9;
    end else begin
        out = 4'd0;
    end
end

endmodule