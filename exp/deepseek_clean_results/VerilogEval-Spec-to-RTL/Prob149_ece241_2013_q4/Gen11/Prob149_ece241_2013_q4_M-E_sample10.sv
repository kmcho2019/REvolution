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
    localparam LEVEL_ABOVE_S2 = 2'b11;
    localparam LEVEL_S2_S1    = 2'b10;
    localparam LEVEL_S1_S0    = 2'b01;
    localparam LEVEL_BELOW_S0 = 2'b00;

    // Current and previous water levels
    reg [1:0] current_level, prev_level;

    // Determine current water level (priority encoder)
    always @(*) begin
        casex (s)
            3'b111:  current_level = LEVEL_ABOVE_S2;
            3'b011:  current_level = LEVEL_S2_S1;
            3'b001:  current_level = LEVEL_S1_S0;
            3'b000:  current_level = LEVEL_BELOW_S0;
            default: current_level = LEVEL_BELOW_S0; // Handle undefined states
        endcase
    end

    // Track previous level
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= LEVEL_BELOW_S0;
        end else begin
            prev_level <= current_level;
        end
    end

    // Nominal flow outputs
    assign fr0 = (reset) ? 1'b1 : (current_level != LEVEL_ABOVE_S2);
    assign fr1 = (reset) ? 1'b1 : (current_level == LEVEL_S1_S0 || current_level == LEVEL_BELOW_S0);
    assign fr2 = (reset) ? 1'b1 : (current_level == LEVEL_BELOW_S0);

    // Supplemental flow (active when water level is rising)
    assign dfr = (reset) ? 1'b1 : (current_level > prev_level && current_level != LEVEL_ABOVE_S2);

endmodule