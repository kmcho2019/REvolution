module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

// Combinational logic for output signals
assign fr2 = ~(s[0] | s[1] | s[2]);
assign fr1 = ~(s[1] | s[2]);
assign fr0 = ~s[2];

// Sequential logic for reset and previous sensor state
always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
        // Check if the current state has more sensors asserted than the previous state
        dfr <= (|s) > (|prev_s);
    end
end

endmodule