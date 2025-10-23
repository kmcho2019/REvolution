module TopModule (
    input [7:0] code,
    output reg [3:0] out = 0,
    output reg valid = 0
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

// Match signals
wire match_0 = (code == SCANCODE_0);
wire match_1 = (code == SCANCODE_1);
wire match_2 = (code == SCANCODE_2);
wire match_3 = (code == SCANCODE_3);
wire match_4 = (code == SCANCODE_4);
wire match_5 = (code == SCANCODE_5);
wire match_6 = (code == SCANCODE_6);
wire match_7 = (code == SCANCODE_7);
wire match_8 = (code == SCANCODE_8);
wire match_9 = (code == SCANCODE_9);

// Valid signal generation
always @(*) begin
    valid = match_0 | match_1 | match_2 | match_3 | match_4 |
            match_5 | match_6 | match_7 | match_8 | match_9;
end

// Output generation
always @(*) begin
    case (1'b1)
        match_0: out = 4'd0;
        match_1: out = 4'd1;
        match_2: out = 4'd2;
        match_3: out = 4'd3;
        match_4: out = 4'd4;
        match_5: out = 4'd5;
        match_6: out = 4'd6;
        match_7: out = 4'd7;
        match_8: out = 4'd8;
        match_9: out = 4'd9;
        default: out = 4'd0;
    endcase
end

endmodule