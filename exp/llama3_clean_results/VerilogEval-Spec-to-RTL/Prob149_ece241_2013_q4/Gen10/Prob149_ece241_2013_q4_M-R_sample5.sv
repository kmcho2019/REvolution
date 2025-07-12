module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] level;
reg [1:0] prev_level;

always @(posedge clk) begin
    if (reset) begin
        level <= 2'b0;
        prev_level <= 2'b0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_level <= level;

        if (s == 3'b000) begin
            level <= 2'b0;  // below
        end else if (s == 3'b001) begin
            level <= 2'b1;  // between
        end else if (s == 3'b011 || s == 3'b101) begin
            level <= 2'b1;  // between
        end else if (s == 3'b111) begin
            level <= 2'b2;  // above
        end
    end
end

assign fr2 = (level == 2'b0 || level == 2'b1) ? 1'b1 : 1'b0;
assign fr1 = (level == 2'b0 || level == 2'b1) ? 1'b1 : 1'b0;
assign fr0 = (level == 2'b0) ? 1'b1 : 1'b0;
assign dfr = (prev_level < level) ? 1'b1 : 1'b0;

endmodule