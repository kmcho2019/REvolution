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
    localparam ABOVE       = 2'd3; // s[0], s[1], s[2] asserted

    reg [1:0] current_state;
    reg [1:0] prev_state;

    // Decode water level from sensors combinationally
    // Exactly match sensor patterns according to problem statement
    function [1:0] decode_region;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b111: decode_region = ABOVE;       // All sensors asserted
                3'b011: decode_region = BETWEEN_2_1; // s[1] and s[0] asserted
                3'b001: decode_region = BETWEEN_1_0; // Only s[0] asserted
                3'b000: decode_region = BELOW;       // No sensors asserted
                default: decode_region = BELOW;       // Treat any other pattern as BELOW for safety
            endcase
        end
    endfunction

    wire [1:0] decoded_state = decode_region(s);

    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW;
            prev_state    <= BELOW;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1; // Supplemental valve active after reset (low water long time)
        end else begin
            prev_state <= current_state;
            current_state <= decoded_state;

            // Set nominal flow valves per problem spec
            case (decoded_state)
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

            // Supplemental valve 'dfr' active only if water level rising
            if (current_state > prev_state)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;
        end
    end

endmodule