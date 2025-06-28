module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] anyedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    // Detect edges for each bit
    for (int i=0; i<8; i=i+1) begin
        if (in[i] != prev_in[i]) begin
            anyedge[i] <= 1;
        end else begin
            anyedge[i] <= 0;
        end
    end
    prev_in <= in;
end

endmodule