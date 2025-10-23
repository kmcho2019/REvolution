module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // State encoding (higher number = higher water level)
    localparam LEVEL_BELOW_S0       = 2'b00;
    localparam LEVEL_BETWEEN_S1_S0  = 2'b01;
    localparam LEVEL_BETWEEN_S2_S1  = 2'b10;
    localparam LEVEL_ABOVE_S2       = 2'b11;

    reg [1:0] current_level;
    reg [1:0] prev_level;

    // Level detection (combinational)
    wire [1:0] detected_level;
    assign detected_level = (s == 3'b111) ? LEVEL_ABOVE_S2 :
                           (s == 3'b011) ? LEVEL_BETWEEN_S2_S1 :
                           (s == 3'b001) ? LEVEL_BETWEEN_S1_S0 :
                           LEVEL_BELOW_S0;  // default case

    // State update (sequential)
    always @(posedge clk) begin
        if (reset) begin
            current_level <= LEVEL_BELOW_S0;
            prev_level <= LEVEL_BELOW_S0;
        end else begin
            prev_level <= current_level;
            current_level <= detected_level;
        end
    end

    // Output generation (combinational)
    assign fr2 = (current_level == LEVEL_BELOW_S0);
    assign fr1 = (current_level == LEVEL_BELOW_S0) || 
                 (current_level == LEVEL_BETWEEN_S1_S0);
    assign fr0 = (current_level != LEVEL_ABOVE_S2);
    assign dfr = (current_level > prev_level) && (current_level != LEVEL_ABOVE_S2);

endmodule