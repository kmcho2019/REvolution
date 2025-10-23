module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

// Pipeline stage for each bit of the input vector
for (genvar i = 0; i < 8; i++) begin
    reg prev_bit;
    
    always @(posedge clk) begin
        prev_bit <= in[i];
        anyedge[i] <= in[i] ^ prev_bit;
    end
end

endmodule