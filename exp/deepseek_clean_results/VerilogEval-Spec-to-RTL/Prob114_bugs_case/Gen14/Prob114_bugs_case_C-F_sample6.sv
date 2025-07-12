module TopModule (
    input [7:0] code,
    output reg [3:0] out,
    output reg valid
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

always @(*) begin
    // Default outputs
    out = 4'd0;
    valid = 1'b0;
    
    // Case statement for efficient decoding
    case (code)
        CODE_0: begin out = 4'd0; valid = 1'b1; end
        CODE_1: begin out = 4'd1; valid = 1'b1; end
        CODE_2: begin out = 4'd2; valid = 1'b1; end
        CODE_3: begin out = 4'd3; valid = 1'b1; end
        CODE_4: begin out = 4'd4; valid = 1'b1; end
        CODE_5: begin out = 4'd5; valid = 1'b1; end
        CODE_6: begin out = 4'd6; valid = 1'b1; end
        CODE_7: begin out = 4'd7; valid = 1'b1; end
        CODE_8: begin out = 4'd8; valid = 1'b1; end
        CODE_9: begin out = 4'd9; valid = 1'b1; end
    endcase
end

endmodule