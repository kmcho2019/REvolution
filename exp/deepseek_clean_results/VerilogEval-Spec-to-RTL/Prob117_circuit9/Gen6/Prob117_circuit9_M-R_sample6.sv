module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] counter;
wire [2:0] comb_out = 3'd4;

always @(posedge clk) begin
    if (!a) begin
        counter <= (counter == 3'd6) ? 3'd0 : counter + 3'd1;
    end
end

assign q = a ? comb_out : counter;

// Initialize counter to 4
initial begin
    counter = 3'd4;
end

endmodule