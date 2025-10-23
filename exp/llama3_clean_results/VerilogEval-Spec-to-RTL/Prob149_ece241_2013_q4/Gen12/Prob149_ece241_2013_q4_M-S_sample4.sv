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

always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        fr2 <= ~(s[0] | s[1] | s[2]); // fr2 is high only when all sensors are low
        fr1 <= ~(s[1] | s[2]); // fr1 is high when s[1] and s[2] are low
        fr0 <= ~s[2]; // fr0 is high when s[2] is low
        dfr <= (prev_s < s); // Set dfr based on the comparison of previous and current sensor states
        prev_s <= s;
    end
end

endmodule