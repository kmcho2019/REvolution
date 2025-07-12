module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;

    // State encoding
    localparam ABOVE_ALL  = 2'b00;
    localparam BTW_S2_S1  = 2'b01;
    localparam BTW_S1_S0  = 2'b10;
    localparam BELOW_ALL  = 2'b11;

    function [1:0] get_state(input [2:0] sensors);
        case (sensors)
            3'b111: get_state = ABOVE_ALL;
            3'b011: get_state = BTW_S2_S1;
            3'b001: get_state = BTW_S1_S0;
            3'b000: get_state = BELOW_ALL;
            default: get_state = BELOW_ALL; // Default to lowest state
        endcase
    endfunction

    wire [1:0] current_state = get_state(s);
    wire [1:0] prev_state = get_state(prev_s);

    always @(posedge clk) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} <= 4'b1111;
            prev_s <= 3'b000;
        end else begin
            // Update previous sensor state
            prev_s <= s;

            // Set nominal flow outputs
            case (current_state)
                ABOVE_ALL:  {fr2, fr1, fr0} = 3'b000;
                BTW_S2_S1: {fr2, fr1, fr0} = 3'b001;
                BTW_S1_S0: {fr2, fr1, fr0} = 3'b011;
                BELOW_ALL: {fr2, fr1, fr0} = 3'b111;
            endcase

            // Set supplemental flow output
            dfr <= (current_state > prev_state) || (current_state == BELOW_ALL);
        end
    end

endmodule