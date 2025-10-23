module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Define water levels for clarity
    localparam LEVEL_BELOW  = 2'd0; // No sensors asserted
    localparam LEVEL_S0     = 2'd1; // Only s[0] asserted
    localparam LEVEL_S1_S0  = 2'd2; // s[0] and s[1] asserted
    localparam LEVEL_ABOVE  = 2'd3; // All sensors asserted s[0],s[1],s[2]

    reg [1:0] current_level;
    reg [1:0] prev_level;

    // Combinational function to decode sensor input to water level
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            // Prioritize highest valid pattern from problem description
            case (sensors)
                3'b111: decode_level = LEVEL_ABOVE;
                3'b011: decode_level = LEVEL_S1_S0;
                3'b001: decode_level = LEVEL_S0;
                default: decode_level = LEVEL_BELOW;
            endcase
        end
    endfunction

    wire [1:0] next_level = decode_level(s);

    // Sequential logic to update current and previous water levels, and dfr signal
    always @(posedge clk) begin
        if (reset) begin
            // Reset to lowest level and assert all flows as per spec
            current_level <= LEVEL_BELOW;
            prev_level    <= LEVEL_BELOW;
            dfr           <= 1'b1;
        end else begin
            // Update levels
            prev_level    <= current_level;
            current_level <= next_level;

            // dfr asserted if current level strictly greater than previous
            dfr <= (next_level > current_level) ? 1'b1 : 1'b0;
        end
    end

    // Nominal flow outputs assigned combinationally from current_level
    // According to problem:
    // Above s[2]: no nominal flow (all zero)
    // Between s[2] and s[1]: fr0=1, fr1=0, fr2=0
    // Between s[1] and s[0]: fr0=1, fr1=1, fr2=0
    // Below s[0]: fr0=1, fr1=1, fr2=1

    assign fr0 = (current_level != LEVEL_ABOVE);
    assign fr1 = (current_level == LEVEL_S0) || (current_level == LEVEL_BELOW);
    assign fr2 = (current_level == LEVEL_BELOW);

endmodule