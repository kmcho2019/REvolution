module TopModule (
  input clk,
  input [7:0] d,
  input areset,
  output reg [7:0] q
);

reg [7:0] q_internal;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        q_internal <= 8'b0;
    end
    else begin
        q_internal <= {q_internal[6:0], d[0]};
    end
end

assign q = q_internal;

endmodule