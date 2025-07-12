module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // State encoding - ordered by water level (00 = lowest)
    localparam LEVEL_BELOW_S0  = 2'b00;
    localparam LEVEL_BTW_S1_S0 = 2'b01;
    localparam LEVEL_BTW_S2_S1 = 2'b10;
    localparam LEVEL_ABOVE_S2  = 2'b11;

    reg [1:0] current_level, prev_level;

    // State update and level detection
    always @(posedge clk) begin
        if (reset) begin
            current_level <= LEVEL_BELOW_S0;
            prev_level <= LEVEL_BELOW_S0;
        end else begin
            prev_level <= current_level;
            casez (s)
                3'b111:  current_level <= LEVEL_ABOVE_S2;
                3'b011:  current_level <= LEVEL_BTW_S2_S1;
                3'b001:  current_level <= LEVEL_BTW_S1_S0;
                3'b000:  current_level <= LEVEL_BELOW_S0;
                default: current_level <= LEVEL_BELOW_S0;
            endcase
        end
    end

    // Output logic (including reset response)
    assign fr0 = reset ? 1'b1 : ((current_level == LEVEL_BTW_S1_S0) || 
                                  (current_level == LEVEL_BELOW_S0));
    assign fr1 = reset ? 1'b1 : ((current_level == LEVEL_BTW_S1_S0) || 
                                  (current_level == LEVEL_BELOW_S0));
    assign fr2 = reset ? 1'b1 : (current_level == LEVEL_BELOW_S0);
    assign dfr = reset ? 1'b1 : (current_level > prev_level);

endmodule