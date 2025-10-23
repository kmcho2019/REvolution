module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] counter;

wire increment;
assign increment = slowena && (counter == 4'b1001)? 1'b0 : slowena;

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0000;
    end else if (increment) begin
        counter <= (counter == 4'b1001)? 4'b0000 : counter + 1;
    end
end

assign q = counter;

endmodule