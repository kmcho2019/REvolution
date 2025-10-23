module TopModule (
    input [7:0] code,
    output reg [3:0] out = 4'b0,
    output reg valid = 1'b0
);

// Named parameters for scancodes and outputs
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

localparam OUT_0 = 4'd0;
localparam OUT_1 = 4'd1;
localparam OUT_2 = 4'd2;
localparam OUT_3 = 4'd3;
localparam OUT_4 = 4'd4;
localparam OUT_5 = 4'd5;
localparam OUT_6 = 4'd6;
localparam OUT_7 = 4'd7;
localparam OUT_8 = 4'd8;
localparam OUT_9 = 4'd9;

always @(*) begin
    // Explicit default assignments (helps synthesis)
    {out, valid} = {4'b0, 1'b0};
    
    // Priority encoder style case statement
    case (1'b1)
        (code == SCANCODE_0): begin out = OUT_0; valid = 1'b1; end
        (code == SCANCODE_1): begin out = OUT_1; valid = 1'b1; end
        (code == SCANCODE_2): begin out = OUT_2; valid = 1'b1; end
        (code == SCANCODE_3): begin out = OUT_3; valid = 1'b1; end
        (code == SCANCODE_4): begin out = OUT_4; valid = 1'b1; end
        (code == SCANCODE_5): begin out = OUT_5; valid = 1'b1; end
        (code == SCANCODE_6): begin out = OUT_6; valid = 1'b1; end
        (code == SCANCODE_7): begin out = OUT_7; valid = 1'b1; end
        (code == SCANCODE_8): begin out = OUT_8; valid = 1'b1; end
        (code == SCANCODE_9): begin out = OUT_9; valid = 1'b1; end
        default: {out, valid} = {4'b0, 1'b0};
    endcase
end

endmodule