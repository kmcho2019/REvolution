module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state; // 0: LOW, 1: BETWEEN_LOW_AND_MIDDLE, 2: BETWEEN_MIDDLE_AND_HIGH, 3: HIGH
reg [2:0] prev_s;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_s <= s;
        case (state)
            0: begin // LOW
                if (s[0]) begin
                    state <= 1;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else begin
                    state <= 0;
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end
            end
            1: begin // BETWEEN_LOW_AND_MIDDLE
                if (s[1]) begin
                    state <= 2;
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= s[1] && !prev_s[1];
                end else if (!s[0]) begin
                    state <= 0;
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else begin
                    state <= 1;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= s[0] && !prev_s[0];
                end
            end
            2: begin // BETWEEN_MIDDLE_AND_HIGH
                if (s[2]) begin
                    state <= 3;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end else if (!s[1]) begin
                    state <= 1;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= s[1] && !prev_s[1];
                end else begin
                    state <= 2;
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= s[1] && !prev_s[1];
                end
            end
            3: begin // HIGH
                if (!s[2]) begin
                    state <= 2;
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else begin
                    state <= 3;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
            end
        endcase
    end
end

endmodule