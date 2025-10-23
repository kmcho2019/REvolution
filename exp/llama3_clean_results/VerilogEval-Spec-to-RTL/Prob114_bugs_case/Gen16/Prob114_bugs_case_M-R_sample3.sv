module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output reg valid
);

    parameter [7:0] scancode_0 = 8'h45;
    parameter [7:0] scancode_1 = 8'h16;
    parameter [7:0] scancode_2 = 8'h1e;
    parameter [7:0] scancode_3 = 8'h26;
    parameter [7:0] scancode_4 = 8'h25;
    parameter [7:0] scancode_5 = 8'h2e;
    parameter [7:0] scancode_6 = 8'h36;
    parameter [7:0] scancode_7 = 8'h3d;
    parameter [7:0] scancode_8 = 8'h3e;
    parameter [7:0] scancode_9 = 8'h46;

    always @(*) begin
        case (code)
            scancode_0: begin out = 4'd0; valid = 1'b1; end
            scancode_1: begin out = 4'd1; valid = 1'b1; end
            scancode_2: begin out = 4'd2; valid = 1'b1; end
            scancode_3: begin out = 4'd3; valid = 1'b1; end
            scancode_4: begin out = 4'd4; valid = 1'b1; end
            scancode_5: begin out = 4'd5; valid = 1'b1; end
            scancode_6: begin out = 4'd6; valid = 1'b1; end
            scancode_7: begin out = 4'd7; valid = 1'b1; end
            scancode_8: begin out = 4'd8; valid = 1'b1; end
            scancode_9: begin out = 4'd9; valid = 1'b1; end
            default: begin out = 4'd0; valid = 1'b0; end
        endcase
    end

endmodule