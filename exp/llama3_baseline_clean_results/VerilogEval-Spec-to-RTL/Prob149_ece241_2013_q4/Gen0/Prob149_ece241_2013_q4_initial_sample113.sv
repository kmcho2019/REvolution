module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg [2:0] state, next_state;
    reg [2:0] prev_s;
    reg fr2_reg, fr1_reg, fr0_reg, dfr_reg;

    // States: 3'b000 - below_s0, 3'b001 - between_s1_s0, 3'b010 - between_s2_s1, 3'b011 - above_s2
    localparam below_s0 = 3'b000;
    localparam between_s1_s0 = 3'b001;
    localparam between_s2_s1 = 3'b010;
    localparam above_s2 = 3'b011;

    always @(*) begin
        next_state = state;
        fr2_reg = 1'b0;
        fr1_reg = 1'b0;
        fr0_reg = 1'b0;
        dfr_reg = 1'b0;

        case (state)
            above_s2: begin
                if (~s[2]) begin
                    next_state = between_s2_s1;
                    if (s[1]) begin
                        fr0_reg = 1'b1;
                    end
                end
            end
            between_s2_s1: begin
                if (s[2]) begin
                    next_state = above_s2;
                end else if (~s[1]) begin
                    next_state = between_s1_s0;
                    fr0_reg = 1'b1;
                    fr1_reg = 1'b1;
                end else begin
                    fr0_reg = 1'b1;
                    if ((s[2:0] > prev_s) && (prev_s != 3'b000)) begin
                        dfr_reg = 1'b1;
                    end
                end
            end
            between_s1_s0: begin
                if (s[1]) begin
                    next_state = between_s2_s1;
                    fr1_reg = 1'b0;
                end else if (~s[0]) begin
                    next_state = below_s0;
                    fr0_reg = 1'b1;
                    fr1_reg = 1'b1;
                    fr2_reg = 1'b1;
                end else begin
                    fr0_reg = 1'b1;
                    fr1_reg = 1'b1;
                    if ((s[2:0] > prev_s) && (prev_s != 3'b000)) begin
                        dfr_reg = 1'b1;
                    end
                end
            end
            below_s0: begin
                if (s[0]) begin
                    next_state = between_s1_s0;
                    fr2_reg = 1'b0;
                end else begin
                    fr0_reg = 1'b1;
                    fr1_reg = 1'b1;
                    fr2_reg = 1'b1;
                    if ((s[2:0] > prev_s) && (prev_s != 3'b000)) begin
                        dfr_reg = 1'b1;
                    end
                end
            end
            default: begin
                next_state = below_s0;
                fr0_reg = 1'b1;
                fr1_reg = 1'b1;
                fr2_reg = 1'b1;
            end
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= below_s0;
            prev_s <= 3'b000;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            state <= next_state;
            prev_s <= s;
            fr2 <= fr2_reg;
            fr1 <= fr1_reg;
            fr0 <= fr0_reg;
            dfr <= dfr_reg;
        end
    end
endmodule