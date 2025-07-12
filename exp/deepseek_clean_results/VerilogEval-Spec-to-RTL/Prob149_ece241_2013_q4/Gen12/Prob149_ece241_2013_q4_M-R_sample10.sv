module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Water level encoding
    localparam LEVEL_ABOVE_S2 = 2'd3;
    localparam LEVEL_S2_TO_S1 = 2'd2;
    localparam LEVEL_S1_TO_S0 = 2'd1;
    localparam LEVEL_BELOW_S0 = 2'd0;

    reg [1:0] current_level, next_level;
    reg level_increased;

    // Combinational level detection
    always @(*) begin
        casez (s)
            3'b??1: next_level = LEVEL_ABOVE_S2;
            3'b?10: next_level = LEVEL_S2_TO_S1;
            3'b100: next_level = LEVEL_S1_TO_S0;
            default: next_level = LEVEL_BELOW_S0;
        endcase
    end

    // Sequential logic for state and transition detection
    always @(posedge clk) begin
        if (reset) begin
            current_level <= LEVEL_BELOW_S0;
            level_increased <= 1'b0;
        end else begin
            level_increased <= (next_level > current_level);
            current_level <= next_level;
        end
    end

    // Output assignments
    assign {fr2, fr1, fr0} = (reset) ? 3'b111 :
                            (current_level == LEVEL_ABOVE_S2) ? 3'b000 :
                            (current_level == LEVEL_S2_TO_S1) ? 3'b001 :
                            (current_level == LEVEL_S1_TO_S0) ? 3'b011 :
                            3'b111;

    assign dfr = (reset) ? 1'b1 :
                level_increased && (current_level != LEVEL_BELOW_S0);

endmodule