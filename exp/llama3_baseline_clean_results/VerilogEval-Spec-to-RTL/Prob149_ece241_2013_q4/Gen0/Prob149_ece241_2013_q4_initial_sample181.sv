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

always @ (posedge clk) begin
    if (reset) begin
        fr2 <= 1;
        fr1 <= 1;
        fr0 <= 1;
        dfr <= 1;
        prev_s <= 3'b000;
    end else begin
        case (s)
            3'b111: begin // Above s[2]
                fr2 <= 0;
                fr1 <= 0;
                fr0 <= 0;
                dfr <= 0;
            end
            3'b110: begin // Between s[2] and s[1]
                fr2 <= 0;
                fr1 <= 0;
                fr0 <= 1;
                if (prev_s < 3'b110) dfr <= 1; else dfr <= 0;
            end
            3'b100: begin // Between s[1] and s[0]
                fr2 <= 0;
                fr1 <= 1;
                fr0 <= 1;
                if (prev_s < 3'b100) dfr <= 1; else dfr <= 0;
            end
            default: begin // Below s[0]
                fr2 <= 1;
                fr1 <= 1;
                fr0 <= 1;
                if (prev_s < 3'b000) dfr <= 1; else dfr <= 0;
            end
        endcase
        prev_s <= s;
    end
end

endmodule