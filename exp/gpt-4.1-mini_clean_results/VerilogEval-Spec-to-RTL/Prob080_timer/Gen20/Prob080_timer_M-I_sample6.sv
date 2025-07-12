module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire enable;
wire [9:0] next_count;

// Enable counter update only if loading or counting down
assign enable = load | (counter != 0);
assign next_count = load ? data : (counter - 1);

always @(posedge clk) begin
    if (enable)
        counter <= next_count;
    // else hold current counter (no explicit else needed)
end

assign tc = (counter == 0);

endmodule