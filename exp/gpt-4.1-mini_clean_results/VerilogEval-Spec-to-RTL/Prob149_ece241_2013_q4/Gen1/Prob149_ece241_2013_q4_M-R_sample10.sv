module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water levels encoding
    // 0 = Below s[0]      (s == 3'b000)
    // 1 = Between s[1],s[0] (s == 3'b001 or s==3'b010)
    // 2 = Between s[2],s[1] (s == 3'b011 or s==3'b100)
    // 3 = Above s[2]        (s == 3'b111, also s==3'b110, s==3'b101 treated as above)
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b000: decode_level = 2'd0; // below s[0]
                3'b001,
                3'b010: decode_level = 2'd1; // between s[1] and s[0]
                3'b011,
                3'b100: decode_level = 2'd2; // between s[2] and s[1]
                3'b111,
                3'b110,
                3'b101: decode_level = 2'd3; // above s[2]
                default: decode_level = 2'd0; // default to below s[0]
            endcase
        end
    endfunction

    reg [1:0] current_level;
    reg [1:0] previous_level;

    // Detect if sensor input changed
    wire [1:0] decoded_level;
    assign decoded_level = decode_level(s);

    always @(posedge clk) begin
        if (reset) begin
            // On reset, set levels to lowest and outputs asserted
            current_level <= 2'd0;
            previous_level <= 2'd0;
        end else begin
            // Update current_level every clock
            current_level <= decoded_level;

            // Update previous_level only if sensor level changed
            if (decoded_level != current_level)
                previous_level <= current_level;
        end
    end

    // Outputs driven combinationally from current_level and previous_level
    // Nominal flow valve outputs based on current_level:
    // 3 (above s[2]): fr0=0, fr1=0, fr2=0
    // 2 (between s[2], s[1]): fr0=1, fr1=0, fr2=0
    // 1 (between s[1], s[0]): fr0=1, fr1=1, fr2=0
    // 0 (below s[0]): fr0=1, fr1=1, fr2=1
    assign fr0 = (current_level == 2'd3) ? 1'b0 : 1'b1;
    assign fr1 = (current_level >= 2'd1 && current_level <= 2'd2) ? (current_level == 2'd1 ? 1'b1 : 1'b0) : 
                 (current_level == 2'd0 ? 1'b1 : 1'b0);
    assign fr2 = (current_level == 2'd0) ? 1'b1 : 1'b0;

    // dfr asserted if current_level > previous_level (water rising)
    assign dfr = (current_level > previous_level) ? 1'b1 : 1'b0;

endmodule