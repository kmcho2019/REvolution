module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state; // 0: below s[0], 1: between s[0] and s[1], 2: between s[1] and s[2], 3: above s[2]
reg [1:0] nextState;
reg [2:0] prev_s;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case(state)
            0: begin // below s[0]
                if (s[0]) begin
                    state <= 1;
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
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
            1: begin // between s[0] and s[1]
                if (s[1] && !s[0]) begin
                    state <= 2;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else if (!s[1] && s[0]) begin
                    state <= 0;
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else if (s[1] && s[0]) begin
                    state <= 1;
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end
            end
            2: begin // between s[1] and s[2]
                if (s[2] && !s[1]) begin
                    state <= 3;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end else if (!s[2] && s[1]) begin
                    state <= 1;
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else if (s[2] && s[1]) begin
                    state <= 2;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end
            end
            3: begin // above s[2]
                state <= 3;
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule