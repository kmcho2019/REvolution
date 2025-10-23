module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State definitions based on sensor patterns
    localparam STATE_ABOVE = 3'b111;
    localparam STATE_MID_H = 3'b011;
    localparam STATE_MID_L = 3'b001;
    localparam STATE_BELOW = 3'b000;

    reg [2:0] current_state, prev_state;

    // State detection with all patterns explicitly handled
    always @(*) begin
        case (s)
            3'b111: current_state = STATE_ABOVE;
            3'b011: current_state = STATE_MID_H;
            3'b110,
            3'b101,
            3'b010,
            3'b100: current_state = STATE_MID_H; // Intermediate levels treated as MID_H
            3'b001: current_state = STATE_MID_L;
            3'b000: current_state = STATE_BELOW;
            default: current_state = STATE_BELOW; // Fault condition
        endcase
    end

    // State tracking and output generation
    always @(posedge clk) begin
        if (reset) begin
            prev_state <= STATE_BELOW;
            {fr2, fr1, fr0} <= 3'b111;
            dfr <= 1'b1;
        end else begin
            prev_state <= current_state;

            // Nominal flow outputs
            case (current_state)
                STATE_ABOVE: {fr2, fr1, fr0} = 3'b000;
                STATE_MID_H: {fr2, fr1, fr0} = 3'b001;
                STATE_MID_L: {fr2, fr1, fr0} = 3'b011;
                STATE_BELOW: {fr2, fr1, fr0} = 3'b111;
                default: {fr2, fr1, fr0} = 3'b111;
            endcase

            // Supplemental flow (rising level detection)
            case (current_state)
                STATE_ABOVE: dfr <= (prev_state == STATE_MID_H);
                STATE_MID_H: dfr <= (prev_state == STATE_MID_L) || (prev_state == STATE_BELOW);
                STATE_MID_L: dfr <= (prev_state == STATE_BELOW);
                STATE_BELOW: dfr <= 1'b0;
                default: dfr <= 1'b0;
            endcase
        end
    end

endmodule