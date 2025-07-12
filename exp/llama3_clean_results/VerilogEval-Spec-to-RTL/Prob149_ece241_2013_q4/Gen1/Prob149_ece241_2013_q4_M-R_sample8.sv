module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        prev_s <= 3'b000;
    end else begin
        // Update previous sensor value
        prev_s <= s;
    end
end

assign fr2 = (s == 3'b000) ? 1'b1 : 1'b0;
assign fr1 = (s == 3'b000 || s == 3'b001) ? 1'b1 : 1'b0;
assign fr0 = (s == 3'b000 || s == 3'b001 || s == 3'b011) ? 1'b1 : 1'b0;
assign dfr = (s == 3'b000 || (prev_s < s && (s == 3'b001 || s == 3'b011))) ? 1'b1 : 1'b0;

endmodule