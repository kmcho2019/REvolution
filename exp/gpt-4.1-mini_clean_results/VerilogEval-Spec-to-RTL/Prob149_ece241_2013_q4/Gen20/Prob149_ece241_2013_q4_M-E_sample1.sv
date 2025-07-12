module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Define water levels:
    // 3: above s[2] (s[2] = 1)
    // 2: between s[2] and s[1] (s[2] = 0, s[1] = 1)
    // 1: between s[1] and s[0] (s[1] = 0, s[0] = 1)
    // 0: below s[0] (s[0] = 0)

    reg [1:0] stored_level, last_level;

    // Function to decode sensor input to level
    function [1:0] decode_level(input [2:0] sensors);
        begin
            if (sensors[2])           decode_level = 2'd3; // above highest sensor
            else if (sensors[1])      decode_level = 2'd2; // between s2 and s1
            else if (sensors[0])      decode_level = 2'd1; // between s1 and s0
            else                      decode_level = 2'd0; // below lowest sensor
        end
    endfunction

    wire [1:0] new_level = decode_level(s);

    always @(posedge clk) begin
        if (reset) begin
            // Initialize to lowest level and all outputs asserted including dfr
            stored_level <= 2'd0;
            last_level <= 2'd0;
            dfr <= 1'b1; // supplemental valve open on reset
        end else begin
            if (new_level != stored_level) begin
                // Detect rising transition and update levels
                // If new_level is higher than stored_level, assert dfr for one cycle
                dfr <= (new_level > stored_level) ? 1'b1 : 1'b0;
                last_level <= stored_level;
                stored_level <= new_level;
            end else begin
                // No level change, dfr de-asserted
                dfr <= 1'b0;
            end
        end
    end

    // Assign nominal flow valves based on stored water level
    // level 3: no nominal valves
    // level 2: fr0
    // level 1: fr0, fr1
    // level 0: fr0, fr1, fr2
    assign fr0 = (stored_level != 2'd3);
    assign fr1 = (stored_level <= 2'd1);
    assign fr2 = (stored_level == 2'd0);

endmodule