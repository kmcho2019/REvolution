module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [3:0] state; // One-hot encoding for the states
localparam STATE BELOW_S0 = 4'b0001; // Below s[0]
localparam STATE BETWEEN_S0_S1 = 4'b0010; // Between s[0] and s[1]
localparam STATE BETWEEN_S1_S2 = 4'b0100; // Between s[1] and s[2]
localparam STATE ABOVE_S2 = 4'b1000; // Above s[2]

always @(posedge clk) begin
    if (reset) begin
        state <= BELOW_S0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (state)
            BELOW_S0: begin
                if (s[0]) begin
                    state <= BETWEEN_S0_S1;
                    dfr <= 1'b1;
                end else begin
                    state <= BELOW_S0;
                    dfr <= 1'b0;
                end
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            BETWEEN_S0_S1: begin
                if (s[1]) begin
                    state <= BETWEEN_S1_S2;
                    dfr <= 1'b1;
                end else if (~s[0]) begin
                    state <= BELOW_S0;
                    dfr <= 1'b0;
                end else begin
                    state <= BETWEEN_S0_S1;
                    dfr <= 1'b0;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            BETWEEN_S1_S2: begin
                if (s[2]) begin
                    state <= ABOVE_S2;
                    dfr <= 1'b1;
                end else if (~s[1]) begin
                    state <= BETWEEN_S0_S1;
                    dfr <= 1'b0;
                end else begin
                    state <= BETWEEN_S1_S2;
                    dfr <= 1'b0;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            ABOVE_S2: begin
                if (~s[2]) begin
                    state <= BETWEEN_S1_S2;
                    dfr <= 1'b0;
                end else begin
                    state <= ABOVE_S2;
                    dfr <= 1'b0;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
            default: begin
                state <= BELOW_S0;
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase
    end
end

endmodule