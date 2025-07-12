module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level encoding
    localparam BELOW_S0      = 2'd0; // no sensors asserted
    localparam BETWEEN_S1_S0 = 2'd1; // s[0] only
    localparam BETWEEN_S2_S1 = 2'd2; // s[0] and s[1]
    localparam ABOVE_S2      = 2'd3; // s[0], s[1], s[2]

    // Decode sensors to water level code
    function [1:0] decode_level(input [2:0] sensors);
        begin
            if (sensors[2])
                decode_level = ABOVE_S2;
            else if (sensors[1] && sensors[0])
                decode_level = BETWEEN_S2_S1;
            else if (sensors[0])
                decode_level = BETWEEN_S1_S0;
            else
                decode_level = BELOW_S0;
        end
    endfunction

    reg [1:0] prev_level, curr_level;

    always @(posedge clk) begin
        if (reset) begin
            prev_level <= BELOW_S0;
            curr_level <= BELOW_S0;
        end else begin
            prev_level <= curr_level;
            curr_level <= decode_level(s);
        end
    end

    assign dfr = (curr_level > prev_level);

    assign fr0 = (curr_level != ABOVE_S2);
    assign fr1 = (curr_level == BETWEEN_S1_S0) || (curr_level == BELOW_S0);
    assign fr2 = (curr_level == BELOW_S0);

endmodule