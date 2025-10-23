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
        case (s)
            3'b000: begin // Below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prev_s < s) ? 1'b1 : 1'b0;
            end
            3'b001: begin // Between s[0] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prev_s < s) ? 1'b1 : 1'b0;
            end
            3'b011: begin // Between s[1] and s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (prev_s < s) ? 1'b1 : 1'b0;
            end
            3'b111: begin // Above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
        prev_s <= s;
    end
end

endmodule