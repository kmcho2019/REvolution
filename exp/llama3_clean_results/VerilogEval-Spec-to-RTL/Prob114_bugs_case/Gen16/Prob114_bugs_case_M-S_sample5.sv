module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    reg [3:0] scancode_out [9:0];
    initial begin
        scancode_out[0] = 4'd0;
        scancode_out[1] = 4'd1;
        scancode_out[2] = 4'd2;
        scancode_out[3] = 4'd3;
        scancode_out[4] = 4'd4;
        scancode_out[5] = 4'd5;
        scancode_out[6] = 4'd6;
        scancode_out[7] = 4'd7;
        scancode_out[8] = 4'd8;
        scancode_out[9] = 4'd9;
    end

    always @(*) begin
        valid = 1'b0;
        out = 4'd0;
        case (code)
            8'h45: begin out = scancode_out[0]; valid = 1'b1; end
            8'h16: begin out = scancode_out[1]; valid = 1'b1; end
            8'h1e: begin out = scancode_out[2]; valid = 1'b1; end
            8'h26: begin out = scancode_out[3]; valid = 1'b1; end
            8'h25: begin out = scancode_out[4]; valid = 1'b1; end
            8'h2e: begin out = scancode_out[5]; valid = 1'b1; end
            8'h36: begin out = scancode_out[6]; valid = 1'b1; end
            8'h3d: begin out = scancode_out[7]; valid = 1'b1; end
            8'h3e: begin out = scancode_out[8]; valid = 1'b1; end
            8'h46: begin out = scancode_out[9]; valid = 1'b1; end
        endcase
    end

endmodule