module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output        valid
);

always @* begin
    case (code)
        8'h45: out = 4'd0;
        8'h16: out = 4'd1;
        8'h1E: out = 4'd2;
        8'h26: out = 4'd3;
        8'h25: out = 4'd4;
        8'h2E: out = 4'd5;
        8'h36: out = 4'd6;
        8'h3D: out = 4'd7;
        8'h3E: out = 4'd8;
        8'h46: out = 4'd9;
        default: out = 4'd0;
    endcase
end

// valid is true if out corresponds to a recognized digit (0-9) and code matches
// Using the fact that only the ten codes above produce digits 0-9
assign valid = (code == 8'h45) || (code == 8'h16) || (code == 8'h1E) || (code == 8'h26) ||
               (code == 8'h25) || (code == 8'h2E) || (code == 8'h36) || (code == 8'h3D) ||
               (code == 8'h3E) || (code == 8'h46);

endmodule