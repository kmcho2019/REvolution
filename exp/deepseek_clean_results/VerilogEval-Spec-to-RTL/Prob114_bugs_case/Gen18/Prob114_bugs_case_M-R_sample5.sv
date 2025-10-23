module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Define scancode constants
localparam SCANCODE_0 = 8'h45;
localparam SCANCODE_1 = 8'h16;
localparam SCANCODE_2 = 8'h1e;
localparam SCANCODE_3 = 8'h26;
localparam SCANCODE_4 = 8'h25;
localparam SCANCODE_5 = 8'h2e;
localparam SCANCODE_6 = 8'h36;
localparam SCANCODE_7 = 8'h3d;
localparam SCANCODE_8 = 8'h3e;
localparam SCANCODE_9 = 8'h46;

// Output assignment using nested ternary operators
assign out = (code == SCANCODE_0) ? 4'd0 :
             (code == SCANCODE_1) ? 4'd1 :
             (code == SCANCODE_2) ? 4'd2 :
             (code == SCANCODE_3) ? 4'd3 :
             (code == SCANCODE_4) ? 4'd4 :
             (code == SCANCODE_5) ? 4'd5 :
             (code == SCANCODE_6) ? 4'd6 :
             (code == SCANCODE_7) ? 4'd7 :
             (code == SCANCODE_8) ? 4'd8 :
             (code == SCANCODE_9) ? 4'd9 : 4'd0;

// Valid signal is high when any valid code is detected
assign valid = (code == SCANCODE_0) ||
               (code == SCANCODE_1) ||
               (code == SCANCODE_2) ||
               (code == SCANCODE_3) ||
               (code == SCANCODE_4) ||
               (code == SCANCODE_5) ||
               (code == SCANCODE_6) ||
               (code == SCANCODE_7) ||
               (code == SCANCODE_8) ||
               (code == SCANCODE_9);

endmodule