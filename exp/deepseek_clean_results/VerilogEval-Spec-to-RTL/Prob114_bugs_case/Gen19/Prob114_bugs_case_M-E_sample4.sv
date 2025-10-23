module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Define all valid codes
localparam [7:0] CODE_0 = 8'h45;
localparam [7:0] CODE_1 = 8'h16;
localparam [7:0] CODE_2 = 8'h1e;
localparam [7:0] CODE_3 = 8'h26;
localparam [7:0] CODE_4 = 8'h25;
localparam [7:0] CODE_5 = 8'h2e;
localparam [7:0] CODE_6 = 8'h36;
localparam [7:0] CODE_7 = 8'h3d;
localparam [7:0] CODE_8 = 8'h3e;
localparam [7:0] CODE_9 = 8'h46;

// Parallel comparison network
wire match_0 = (code == CODE_0);
wire match_1 = (code == CODE_1);
wire match_2 = (code == CODE_2);
wire match_3 = (code == CODE_3);
wire match_4 = (code == CODE_4);
wire match_5 = (code == CODE_5);
wire match_6 = (code == CODE_6);
wire match_7 = (code == CODE_7);
wire match_8 = (code == CODE_8);
wire match_9 = (code == CODE_9);

// Generate valid signal
assign valid = match_0 | match_1 | match_2 | match_3 | match_4 |
               match_5 | match_6 | match_7 | match_8 | match_9;

// Priority encoder for output
assign out = match_0 ? 4'd0 :
             match_1 ? 4'd1 :
             match_2 ? 4'd2 :
             match_3 ? 4'd3 :
             match_4 ? 4'd4 :
             match_5 ? 4'd5 :
             match_6 ? 4'd6 :
             match_7 ? 4'd7 :
             match_8 ? 4'd8 :
             match_9 ? 4'd9 :
             4'd0;

endmodule