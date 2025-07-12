module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] counter;

// Clock edge detection
wire clk_posedge;
reg clk_prev;
always @(clk) clk_prev <= clk;
assign clk_posedge = ~clk_prev & clk;

// Counter logic
always @(posedge clk) begin
    if (a) begin
        counter <= 3'd4;
    end else if (clk_posedge) begin
        counter <= (counter == 3'd6) ? 3'd0 : counter + 1;
    end
end

assign q = counter;

endmodule