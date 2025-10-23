module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] johnson_count;

always @(posedge clk) begin
    if (reset) begin
        johnson_count <= 4'b1000;
    end else begin
        johnson_count <= {johnson_count[2:0], ~johnson_count[3]};
    end
end

assign q = johnson_count == 4'b1000? 4'b0000 :
           johnson_count == 4'b1100? 4'b0001 :
           johnson_count == 4'b1110? 4'b0010 :
           johnson_count == 4'b1111? 4'b0011 :
           johnson_count == 4'b0111? 4'b0100 :
           johnson_count == 4'b0110? 4'b0101 :
           johnson_count == 4'b0010? 4'b0110 :
           johnson_count == 4'b0011? 4'b0111 :
           johnson_count == 4'b0001? 4'b1000 :
           johnson_count == 4'b0000? 4'b1001 :
           johnson_count == 4'b1001? 4'b1010 :
           johnson_count == 4'b1010? 4'b1011 :
           johnson_count == 4'b1011? 4'b1100 :
           johnson_count == 4'b1101? 4'b1101 :
           4'b1111;

endmodule