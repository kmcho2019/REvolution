module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [9:0] johnson_counter;

always @(posedge clk) begin
    if (reset) begin
        johnson_counter <= 10'b1000000000;
    end else if (slowena) begin
        johnson_counter <= {johnson_counter[8:0], johnson_counter[9]};
    end
end

assign q = johnson_counter[9:6]? 4'b1001 : johnson_counter[8:5];

endmodule