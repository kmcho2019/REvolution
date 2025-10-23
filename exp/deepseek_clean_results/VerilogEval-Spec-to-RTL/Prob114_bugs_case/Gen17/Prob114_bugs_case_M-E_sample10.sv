module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Scancode definitions
localparam [7:0] SCANCODE_0 = 8'h45;
localparam [7:0] SCANCODE_1 = 8'h16;
localparam [7:0] SCANCODE_2 = 8'h1e;
localparam [7:0] SCANCODE_3 = 8'h26;
localparam [7:0] SCANCODE_4 = 8'h25;
localparam [7:0] SCANCODE_5 = 8'h2e;
localparam [7:0] SCANCODE_6 = 8'h36;
localparam [7:0] SCANCODE_7 = 8'h3d;
localparam [7:0] SCANCODE_8 = 8'h3e;
localparam [7:0] SCANCODE_9 = 8'h46;

// One-hot key detection
wire [9:0] key_detect;
assign key_detect[0] = (code == SCANCODE_0);
assign key_detect[1] = (code == SCANCODE_1);
assign key_detect[2] = (code == SCANCODE_2);
assign key_detect[3] = (code == SCANCODE_3);
assign key_detect[4] = (code == SCANCODE_4);
assign key_detect[5] = (code == SCANCODE_5);
assign key_detect[6] = (code == SCANCODE_6);
assign key_detect[7] = (code == SCANCODE_7);
assign key_detect[8] = (code == SCANCODE_8);
assign key_detect[9] = (code == SCANCODE_9);

// Valid signal generation
assign valid = |key_detect;

// Priority encoder for binary output
assign out = key_detect[9] ? 4'd9 :
             key_detect[8] ? 4'd8 :
             key_detect[7] ? 4'd7 :
             key_detect[6] ? 4'd6 :
             key_detect[5] ? 4'd5 :
             key_detect[4] ? 4'd4 :
             key_detect[3] ? 4'd3 :
             key_detect[2] ? 4'd2 :
             key_detect[1] ? 4'd1 :
             key_detect[0] ? 4'd0 :
             4'd0;

endmodule