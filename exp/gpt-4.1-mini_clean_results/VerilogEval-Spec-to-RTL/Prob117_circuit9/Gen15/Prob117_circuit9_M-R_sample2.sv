module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;
    end else begin
        case (q)
            3'd4: q <= 3'd5;
            3'd5: q <= 3'd6;
            3'd6: q <= 3'd0;
            3'd0: q <= 3'd1;
            3'd1: q <= 3'd2;
            3'd2: q <= 3'd3;
            3'd3: q <= 3'd4;
            default: q <= 3'd4;
        endcase
    end
end

endmodule