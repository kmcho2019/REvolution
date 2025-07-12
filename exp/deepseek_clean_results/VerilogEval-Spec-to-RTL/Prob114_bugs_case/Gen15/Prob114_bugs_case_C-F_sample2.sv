module TopModule (
    input [7:0] code,
    output reg [3:0] out = 0,
    output reg valid = 0
);

// Named parameters for scancodes
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

always @(*) begin
    // Default assignments (power optimization)
    out = 0;
    valid = 0;
    
    // Parallel decoding of valid scancodes
    case (code)
        SCANCODE_0: begin out = 4'd0; valid = 1'b1; end
        SCANCODE_1: begin out = 4'd1; valid = 1'b1; end
        SCANCODE_2: begin out = 4'd2; valid = 1'b1; end
        SCANCODE_3: begin out = 4'd3; valid = 1'b1; end
        SCANCODE_4: begin out = 4'd4; valid = 1'b1; end
        SCANCODE_5: begin out = 4'd5; valid = 1'b1; end
        SCANCODE_6: begin out = 4'd6; valid = 1'b1; end
        SCANCODE_7: begin out = 4'd7; valid = 1'b1; end
        SCANCODE_8: begin out = 4'd8; valid = 1'b1; end
        SCANCODE_9: begin out = 4'd9; valid = 1'b1; end
    endcase
end

endmodule