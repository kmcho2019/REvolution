module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg prev_s2, prev_s1, prev_s0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s2 <= 1'b0;
        prev_s1 <= 1'b0;
        prev_s0 <= 1'b0;
    end else begin
        prev_s2 <= s[2];
        prev_s1 <= s[1];
        prev_s0 <= s[0];

        if (s[2] && s[1] && s[0]) begin // above s[2]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s[1] && s[0]) begin // between s[2] and s[1]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            if ((~prev_s1 && s[1]) || (~prev_s0 && s[0])) begin // level rising
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s[0]) begin // between s[1] and s[0]
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if ((~prev_s0 && s[0])) begin // level rising
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else begin // below s[0]
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end
    end
end

endmodule