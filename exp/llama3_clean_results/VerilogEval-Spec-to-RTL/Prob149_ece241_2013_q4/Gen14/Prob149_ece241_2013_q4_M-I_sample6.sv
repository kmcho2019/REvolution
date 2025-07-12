module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output wire fr2,
    output wire fr1,
    output wire fr0,
    output reg dfr
);

reg [2:0] prev_s;

// Combinational logic for output signals
assign fr2 = ~s[0] & ~s[1] & ~s[2];
assign fr1 = ~s[1] & ~s[2];
assign fr0 = ~s[2];

// Sequential logic for reset and previous sensor state
always @(posedge clk) begin
    if (reset) begin
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        if (s > prev_s) begin
            dfr <= 1'b1;
        end else if (s < prev_s) begin
            dfr <= 1'b0;
        end
        prev_s <= s;
    end
end

endmodule