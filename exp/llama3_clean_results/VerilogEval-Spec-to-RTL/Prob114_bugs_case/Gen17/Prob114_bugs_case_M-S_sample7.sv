module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    always @(*) begin
        out = 4'd0;
        valid = 1'b0;
        case (code)
            8'h45, 8'h16, 8'h1e, 8'h26, 8'h25, 8'h2e, 8'h36, 8'h3d, 8'h3e, 8'h46: begin
                out = (code == 8'h45) ? 4'd0 :
                      (code == 8'h16) ? 4'd1 :
                      (code == 8'h1e) ? 4'd2 :
                      (code == 8'h26) ? 4'd3 :
                      (code == 8'h25) ? 4'd4 :
                      (code == 8'h2e) ? 4'd5 :
                      (code == 8'h36) ? 4'd6 :
                      (code == 8'h3d) ? 4'd7 :
                      (code == 8'h3e) ? 4'd8 :
                                         4'd9;
                valid = 1'b1;
            end
        endcase
    end

endmodule