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

    reg [1:0] current_level, previous_level;

    // Combinational level detection
    always @(*) begin
        case (s)
            3'b111: current_level = LEVEL_ABOVE_S2;
            3'b011: current_level = LEVEL_ABOVE_S2;
            3'b001: current_level = LEVEL_ABOVE_S2;
            3'b110: current_level = LEVEL_S2_TO_S1;
            3'b010: current_level = LEVEL_S2_TO_S1;
            3'b100: current_level = LEVEL_S1_TO_S0;
            default: current_level = LEVEL_BELOW_S0; // 000 or others
        endcase
    end

    // Sequential logic for tracking previous level
    always @(posedge clk) begin
        if (reset) begin
            previous_level <= LEVEL_BELOW_S0;
        end else begin
            previous_level <= current_level;
        end
    end

    // Output assignments
    assign fr0 = (current_level != LEVEL_ABOVE_S2);
    assign fr1 = (current_level == LEVEL_S1_TO_S0) || (current_level == LEVEL_BELOW_S0);
    assign fr2 = (current_level == LEVEL_BELOW_S0);
    assign dfr = (reset) ? 1'b1 : 
                ((current_level > previous_level) && (current_level != LEVEL_ABOVE_S2));

endmodule