module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // State encoding representing water levels (monotonically increasing)
    localparam BELOW       = 2'd0; // No sensors asserted
    localparam BETWEEN_1_0 = 2'd1; // Only s[0] asserted
    localparam BETWEEN_2_1 = 2'd2; // s[0] and s[1] asserted
    localparam ABOVE       = 2'd3; // All sensors asserted

    reg [1:0] current_state, prev_state;
    reg [1:0] next_state;

    // Decode water level from sensors, prioritizing highest levels first
    function [1:0] decode_region;
        input [2:0] sensors;
        begin
            if (sensors[2] && sensors[1] && sensors[0]) begin
                decode_region = ABOVE;
            end else if (!sensors[2] && sensors[1] && sensors[0]) begin
                decode_region = BETWEEN_2_1;
            end else if (!sensors[2] && !sensors[1] && sensors[0]) begin
                decode_region = BETWEEN_1_0;
            end else if (sensors == 3'b000) begin
                decode_region = BELOW;
            end else begin
                if (sensors[2]) decode_region = ABOVE;
                else if (sensors[1]) decode_region = BETWEEN_2_1;
                else if (sensors[0]) decode_region = BETWEEN_1_0;
                else decode_region = BELOW;
            end
        end
    endfunction

    // Synchronous state updates and outputs
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW;
            prev_state    <= BELOW;
            // Reset outputs to correspond to BELOW level (all valves open)
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1; // According to spec, reset state acts as if water level has been low long time, dfr set
        end else begin
            prev_state <= current_state;
            next_state <= decode_region(s);
            current_state <= next_state;

            // Nominal flow valve outputs per problem statement
            case (next_state)
                ABOVE: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_2_1: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_1_0: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                BELOW: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // Supplemental flow valve dfr asserted if water level rises (next_state > prev_state)
            if (next_state > prev_state)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;
        end
    end

endmodule