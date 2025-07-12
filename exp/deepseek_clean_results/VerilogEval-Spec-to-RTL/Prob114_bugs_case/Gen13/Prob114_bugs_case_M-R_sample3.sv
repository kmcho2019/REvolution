module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Define scancode constants
localparam CODE_0 = 8'h45;
localparam CODE_1 = 8'h16;
localparam CODE_2 = 8'h1e;
localparam CODE_3 = 8'h26;
localparam CODE_4 = 8'h25;
localparam CODE_5 = 8'h2e;
localparam CODE_6 = 8'h36;
localparam CODE_7 = 8'h3d;
localparam CODE_8 = 8'h3e;
localparam CODE_9 = 8'h46;

// Generate valid signal
assign valid = (code == CODE_0) || (code == CODE_1) || (code == CODE_2) ||
               (code == CODE_3) || (code == CODE_4) || (code == CODE_5) ||
               (code == CODE_6) || (code == CODE_7) || (code == CODE_8) ||
               (code == CODE_9);

// Generate output using case statement
assign out = (code == CODE_0) ? 4'd0 :
             (code == CODE_1) ? 4'd1 :
             (code == CODE_2) ? 4'd2 :
             (code == CODE_3) ? 4'd3 :
             (code == CODE_4) ? 4'd4 :
             (code == CODE_5) ? 4'd5 :
             (code == CODE_6) ? 4'd6 :
             (code == CODE_7) ? 4'd7 :
             (code == CODE_8) ? 4'd8 :
             (code == CODE_9) ? 4'd9 :
             4'd0;

endmodule