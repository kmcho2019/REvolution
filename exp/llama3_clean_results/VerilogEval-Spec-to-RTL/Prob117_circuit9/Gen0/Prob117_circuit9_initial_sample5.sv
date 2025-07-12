module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] counter;

always @(posedge clk) begin
    if (~a) begin
        if (counter == 4) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
end

assign q = counter;

initial begin
    counter = 4; // Initialize q to 4 (100 in binary) on power-up
end

endmodule