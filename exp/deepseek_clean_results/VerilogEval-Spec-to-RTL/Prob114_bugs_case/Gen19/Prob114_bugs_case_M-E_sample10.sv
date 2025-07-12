module TopModule (
    input [7:0] code,
    output reg [3:0] out,
    output reg valid
);

// Parallel pattern matching for each valid scancode
wire hit_0 = (code == 8'h45);
wire hit_1 = (code == 8'h16);
wire hit_2 = (code == 8'h1e);
wire hit_3 = (code == 8'h26);
wire hit_4 = (code == 8'h25);
wire hit_5 = (code == 8'h2e);
wire hit_6 = (code == 8'h36);
wire hit_7 = (code == 8'h3d);
wire hit_8 = (code == 8'h3e);
wire hit_9 = (code == 8'h46);

// Generate valid signal (OR of all hits)
always @(*) begin
    valid = hit_0 | hit_1 | hit_2 | hit_3 | hit_4 | 
            hit_5 | hit_6 | hit_7 | hit_8 | hit_9;
end

// Priority encoder for output (though only one hit should occur)
always @(*) begin
    case (1'b1)
        hit_0: out = 4'd0;
        hit_1: out = 4'd1;
        hit_2: out = 4'd2;
        hit_3: out = 4'd3;
        hit_4: out = 4'd4;
        hit_5: out = 4'd5;
        hit_6: out = 4'd6;
        hit_7: out = 4'd7;
        hit_8: out = 4'd8;
        hit_9: out = 4'd9;
        default: out = 4'd0;
    endcase
end

endmodule