module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level states (monotonically increasing)
    localparam BELOW       = 2'd0; // no sensors
    localparam BETWEEN_1_0 = 2'd1; // only s[0]
    localparam BETWEEN_2_1 = 2'd2; // s[1] and s[0]
    localparam ABOVE       = 2'd3; // all sensors asserted

    reg [1:0] current_state, prev_state;

    // Decode water level from sensors
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            if (sensors == 3'b111)       decode_level = ABOVE;
            else if (sensors[1] && sensors[0]) decode_level = BETWEEN_2_1;
            else if (sensors[0])         decode_level = BETWEEN_1_0;
            else                         decode_level = BELOW;
        end
    endfunction

    // Sequential logic to update states
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW;
            prev_state <= BELOW;
        end else begin
            prev_state <= current_state;
            current_state <= decode_level(s);
        end
    end

    // Nominal flow outputs based on current state
    assign fr2 = (current_state == BELOW) ? 1'b1 : 1'b0;
    assign fr1 = (current_state == BELOW || current_state == BETWEEN_1_0) ? 1'b1 : 1'b0;
    assign fr0 = (current_state != ABOVE) ? 1'b1 : 1'b0;

    // Supplemental flow valve asserted when water level rises
    assign dfr = (current_state > prev_state) ? 1'b1 : 1'b0;

endmodule