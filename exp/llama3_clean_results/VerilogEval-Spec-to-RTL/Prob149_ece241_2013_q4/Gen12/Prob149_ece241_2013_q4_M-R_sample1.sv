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
assign fr2 = (s == 3'b000) ? 1'b1 : 1'b0;
assign fr1 = (s == 3'b000 || s == 3'b001) ? 1'b1 : 1'b0;
assign fr0 = (s == 3'b000 || s == 3'b001 || s == 3'b011) ? 1'b1 : 1'b0;
assign dfr = (s > prev_s) ? 1'b1 : 1'b0;

// Sequential logic for state transitions and reset
always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
    end
end

endmodule