module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

always @(*) begin
    valid = 1'b0;
    out = 4'd0;

    if (code == 8'h45) begin
        valid = 1'b1;
        out = 4'd0;
    end else if (code == 8'h16) begin
        valid = 1'b1;
        out = 4'd1;
    end else if (code == 8'h1E) begin
        valid = 1'b1;
        out = 4'd2;
    end else if (code == 8'h26) begin
        valid = 1'b1;
        out = 4'd3;
    end else if (code == 8'h25) begin
        valid = 1'b1;
        out = 4'd4;
    end else if (code == 8'h2E) begin
        valid = 1'b1;
        out = 4'd5;
    end else if (code == 8'h36) begin
        valid = 1'b1;
        out = 4'd6;
    end else if (code == 8'h3D) begin
        valid = 1'b1;
        out = 4'd7;
    end else if (code == 8'h3E) begin
        valid = 1'b1;
        out = 4'd8;
    end else if (code == 8'h46) begin
        valid = 1'b1;
        out = 4'd9;
    end
    // else defaults remain valid=0, out=0
end

endmodule