module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    if (|in) begin
        pos = |in[3:0] ? 
              (in[0] ? 3'd0 :
               in[1] ? 3'd1 :
               in[2] ? 3'd2 :
               3'd3) :
              (in[4] ? 3'd4 :
               in[5] ? 3'd5 :
               in[6] ? 3'd6 :
               3'd7);
    end else begin
        pos = 3'd0;
    end
end

endmodule