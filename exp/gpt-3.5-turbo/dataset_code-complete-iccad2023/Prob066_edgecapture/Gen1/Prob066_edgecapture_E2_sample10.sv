module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);

reg [31:0] prev_in;

always @(posedge clk) begin
    if (reset) begin
        out <= 0;
    end 
    else begin
        for (int i=0; i<32; i=i+1) begin
            if (prev_in[i] && !in[i]) begin
                out[i] <= 1;
            end
            prev_in[i] <= in[i];
        end
    end
end

endmodule