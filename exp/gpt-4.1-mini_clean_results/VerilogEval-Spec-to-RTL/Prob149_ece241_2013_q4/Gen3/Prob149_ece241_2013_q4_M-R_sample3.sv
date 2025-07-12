module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Encode water level from sensors:
    // 0: no sensors asserted (below s0)
    // 1: only s0 asserted (between s1 and s0)
    // 2: s0 and s1 asserted (between s2 and s1)
    // 3: all sensors asserted (above s2)
    function [1:0] get_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b000: get_level = 2'd0;
                3'b001: get_level = 2'd1;
                3'b011: get_level = 2'd2;
                3'b111: get_level = 2'd3;
                default: get_level = 2'd0; // conservative default for unexpected patterns
            endcase
        end
    endfunction

    reg [1:0] prev_level;
    reg [2:0] prev_s;

    wire [1:0] curr_level = get_level(s);

    // Update prev_level and prev_s only on sensor change
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;    // Start as below s0 level
            prev_s <= 3'b000;
        end else if (s != prev_s) begin
            prev_level <= curr_level; // Store previous stable level before change
            prev_s <= s;
        end
    end

    // Nominal flow outputs assigned combinationally from current sensors
    // according to the problem's table
    assign {fr2, fr1, fr0} = (s == 3'b111) ? 3'b000 :  // Above s2 - no flow
                            (s == 3'b011) ? 3'b001 :  // Between s2 and s1 - fr0 only
                            (s == 3'b001) ? 3'b011 :  // Between s1 and s0 - fr0 and fr1
                            (s == 3'b000) ? 3'b111 :  // Below s0 - all flows
                            3'b111;                   // Default conservative (all flows)

    // dfr asserted if water level increased compared to previous stable level
    assign dfr = (curr_level > prev_level) ? 1'b1 : 1'b0;

endmodule