module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] counter;

// sequential logic
always @(posedge clk) begin
    if (reset) begin
        counter = 4;
    end
    else if (counter > 0) begin
        counter = counter - 1;
    end
end

// continuous assignment
assign shift_ena = (counter > 0);

endmodule