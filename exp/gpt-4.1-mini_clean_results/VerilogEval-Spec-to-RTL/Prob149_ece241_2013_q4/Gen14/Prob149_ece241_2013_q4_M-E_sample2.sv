module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // State encoding for water levels
    localparam BELOW_S0      = 2'd0;
    localparam BETWEEN_S0_S1 = 2'd1;
    localparam BETWEEN_S1_S2 = 2'd2;
    localparam ABOVE_S2      = 2'd3;

    reg [1:0] current_state;
    reg [1:0] last_stable_state;

    // Decode sensors into water level state
    // Valid sensor patterns and their corresponding states:
    // 3'b111 => ABOVE_S2
    // 3'b011 => BETWEEN_S1_S2
    // 3'b001 => BETWEEN_S0_S1
    // 3'b000 => BELOW_S0
    // All others => BELOW_S0 (invalid treated as BELOW_S0)

    function [1:0] decode_level(input [2:0] s_in);
        case (s_in)
            3'b111: decode_level = ABOVE_S2;
            3'b011: decode_level = BETWEEN_S1_S2;
            3'b001: decode_level = BETWEEN_S0_S1;
            3'b000: decode_level = BELOW_S0;
            default: decode_level = BELOW_S0;
        endcase
    endfunction

    wire [1:0] decoded_level = decode_level(s);

    // Synchronous logic to update states and outputs
    always @(posedge clk) begin
        if (reset) begin
            // Initialize as if below s0 for a long time, all nominal and supplemental valves open
            current_state    <= BELOW_S0;
            last_stable_state <= BELOW_S0;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Check for state change
            if (decoded_level != current_state) begin
                // State changed: store old current_state in last_stable_state
                last_stable_state <= current_state;
                current_state <= decoded_level;
            end else begin
                // No state change: maintain current_state and last_stable_state
                current_state <= current_state;
                last_stable_state <= last_stable_state;
            end

            // Assign nominal flow valves according to current water level
            case (decoded_level)
                ABOVE_S2: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_S1_S2: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_S0_S1: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                BELOW_S0: begin
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

            // Supplemental flow valve (dfr) is high if water level rose relative to last stable state
            if (decoded_level > last_stable_state) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end
    end

endmodule