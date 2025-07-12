module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

enum {LOW, BETWEEN_S0_S1, BETWEEN_S1_S2, HIGH} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= LOW;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (state)
            LOW: begin
                if (s[0]) begin
                    next_state <= BETWEEN_S0_S1;
                    dfr <= 1'b1;
                end else begin
                    next_state <= LOW;
                    dfr <= 1'b0;
                end
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            BETWEEN_S0_S1: begin
                if (s[1]) begin
                    next_state <= BETWEEN_S1_S2;
                    dfr <= 1'b1;
                end else if (!s[0]) begin
                    next_state <= LOW;
                    dfr <= 1'b0;
                end else begin
                    next_state <= BETWEEN_S0_S1;
                    dfr <= 1'b0;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            BETWEEN_S1_S2: begin
                if (s[2]) begin
                    next_state <= HIGH;
                    dfr <= 1'b1;
                end else if (!s[1]) begin
                    next_state <= BETWEEN_S0_S1;
                    dfr <= 1'b0;
                end else begin
                    next_state <= BETWEEN_S1_S2;
                    dfr <= 1'b0;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            HIGH: begin
                if (!(s[2])) begin
                    next_state <= BETWEEN_S1_S2;
                    dfr <= 1'b0;
                end else begin
                    next_state <= HIGH;
                    dfr <= 1'b0;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
        endcase
        state <= next_state;
    end
end

endmodule