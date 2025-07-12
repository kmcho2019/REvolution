module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s;
reg prev_dfr;

always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_s <= s;
        case ({s[2], s[1], s[0]})
            3'b111: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            3'b110: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (({s[2], s[1], s[0]} > prev_s) && prev_dfr == 1'b0) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            3'b100: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (({s[2], s[1], s[0]} > prev_s) && prev_dfr == 1'b0) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            default: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (({s[2], s[1], s[0]} > prev_s) && prev_dfr == 1'b0) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
        endcase
        prev_dfr <= dfr;
    end
end

endmodule