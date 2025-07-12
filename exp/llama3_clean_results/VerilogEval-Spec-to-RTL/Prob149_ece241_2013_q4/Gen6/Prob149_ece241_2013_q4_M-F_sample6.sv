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
reg [2:0] prev_level;

always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000;
        prev_level <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (s)
            3'b000: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            3'b001: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prev_level < 3'b001)? 1'b1 : 1'b0;
            end
            3'b010, 3'b011: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (prev_level < 3'b010)? 1'b1 : 1'b0;
            end
            3'b100, 3'b101, 3'b110, 3'b111: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= (prev_level < 3'b100)? 1'b1 : 1'b0;
            end
        endcase

        prev_s <= s;
        prev_level <= s;
    end
end

endmodule