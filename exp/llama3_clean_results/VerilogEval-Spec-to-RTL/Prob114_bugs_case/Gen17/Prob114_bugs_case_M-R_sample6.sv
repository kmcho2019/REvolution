module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output valid
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

    reg [3:0] out_reg;
    reg valid_reg;

    always @(*) begin
        case (code)
            scancode_0: begin out_reg = 4'd0; valid_reg = 1'b1; end
            scancode_1: begin out_reg = 4'd1; valid_reg = 1'b1; end
            scancode_2: begin out_reg = 4'd2; valid_reg = 1'b1; end
            scancode_3: begin out_reg = 4'd3; valid_reg = 1'b1; end
            scancode_4: begin out_reg = 4'd4; valid_reg = 1'b1; end
            scancode_5: begin out_reg = 4'd5; valid_reg = 1'b1; end
            scancode_6: begin out_reg = 4'd6; valid_reg = 1'b1; end
            scancode_7: begin out_reg = 4'd7; valid_reg = 1'b1; end
            scancode_8: begin out_reg = 4'd8; valid_reg = 1'b1; end
            scancode_9: begin out_reg = 4'd9; valid_reg = 1'b1; end
            default: begin out_reg = 4'd0; valid_reg = 1'b0; end
        endcase
    end

    assign out = out_reg;
    assign valid = valid_reg;

endmodule