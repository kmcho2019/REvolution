module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg prev_s0;
reg prev_s1;
reg prev_s2;

always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s0 <= 1'b0;
        prev_s1 <= 1'b0;
        prev_s2 <= 1'b0;
    end else begin
        prev_s0 <= s[0];
        prev_s1 <= s[1];
        prev_s2 <= s[2];

        if (s[2] == 1'b1 && s[1] == 1'b1 && s[0] == 1'b1) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s[2] == 1'b0 && s[1] == 1'b1 && s[0] == 1'b1) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            if ((prev_s0 == 1'b0 || prev_s1 == 1'b0 || prev_s2 == 1'b0) && (s[0] == 1'b1 || s[1] == 1'b1 || s[2] == 1'b1)) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s[2] == 1'b0 && s[1] == 1'b0 && s[0] == 1'b1) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if ((prev_s0 == 1'b0 || prev_s1 == 1'b0 || prev_s2 == 1'b0) && (s[0] == 1'b1 || s[1] == 1'b1 || s[2] == 1'b1)) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if ((prev_s0 == 1'b0 || prev_s1 == 1'b0 || prev_s2 == 1'b0) && (s[0] == 1'b1 || s[1] == 1'b1 || s[2] == 1'b1)) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end
    end
end

endmodule