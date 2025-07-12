module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] count; // Counter to track consecutive 1s

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
    end else if (in) begin
        count <= count + 1;
    end else begin
        count <= 0;
    end
end

// Combinational logic for output signals
assign disc = (count == 5) && ~in;
assign flag = (count == 6) && ~in;
assign err = count >= 7;

endmodule