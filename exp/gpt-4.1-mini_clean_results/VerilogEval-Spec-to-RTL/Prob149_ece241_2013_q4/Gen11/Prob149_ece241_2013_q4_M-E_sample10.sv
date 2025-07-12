module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Define water level encoding for outputs and comparisons
    // Sensor pattern to water level mapping:
    // s[2] s[1] s[0]  water level category
    // 111       Above s2
    // 011       Between s2 and s1
    // 001       Between s1 and s0
    // 000       Below s0
    // Any other pattern treated as below s0 for safety

    // Previous sensor pattern register
    reg [2:0] prev_s;

    // Current water level encoded as 2-bit for outputs:
    // 2'b11 = Above s2
    // 2'b10 = Between s2 and s1
    // 2'b01 = Between s1 and s0
    // 2'b00 = Below s0 or invalid pattern
    reg [1:0] level;

    // Decode sensor pattern to level
    always @(*) begin
        case (s)
            3'b111: level = 2'b11; // Above s2
            3'b011: level = 2'b10; // Between s2 and s1
            3'b001: level = 2'b01; // Between s1 and s0
            3'b000: level = 2'b00; // Below s0
            default: level = 2'b00; // Treat others as below s0 for safety
        endcase
    end

    // Nominal flow valves combinational based on level
    // Below s0 (00): fr0=1, fr1=1, fr2=1
    // Between s1 and s0 (01): fr0=1, fr1=1, fr2=0
    // Between s2 and s1 (10): fr0=1, fr1=0, fr2=0
    // Above s2 (11): fr0=0, fr1=0, fr2=0
    assign fr0 = (level != 2'b11);
    assign fr1 = (level == 2'b00) || (level == 2'b01);
    assign fr2 = (level == 2'b00);

    // Detect if water level increased compared to previous sensors
    // Compare previous and current sensor patterns:
    // "Water level increased" means current sensors assert any sensor that was previously not asserted,
    // particularly higher sensors.
    //
    // Implementation: if current sensor pattern > previous pattern in water-level sense
    // or if current has sensors asserted that prev didn't at a higher sensor position
    // (For simplicity, treat sensor pattern as 3-bit value, higher bits more significant).
    //
    // However, since some invalid patterns are forced to below s0, use decoded level comparison.
    //
    // Also, we track previous sensor input directly (prev_s),
    // but dfr based on whether decoded water level increased compared to previous decoded level.
    //
    // So at clock, decode prev_s to prev_level and compare to level:
    // dfr <= (level > prev_level)

    reg [1:0] prev_level;

    // Decode prev_s to prev_level
    wire [1:0] prev_level_w;
    assign prev_level_w = (prev_s == 3'b111) ? 2'b11 :
                          (prev_s == 3'b011) ? 2'b10 :
                          (prev_s == 3'b001) ? 2'b01 : 2'b00;

    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;      // Treat as below s0 after reset
            prev_level <= 2'b00;
            dfr <= 1'b1;           // Supplemental flow valve open on reset (long low-level)
        end else begin
            prev_s <= s;
            prev_level <= prev_level_w;
            dfr <= (level > prev_level_w); // dfr asserted if water level increased
        end
    end

endmodule