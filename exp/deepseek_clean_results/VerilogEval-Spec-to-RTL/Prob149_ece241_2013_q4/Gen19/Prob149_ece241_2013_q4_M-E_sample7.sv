module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Priority encoded water level
    reg [1:0] current_level, prev_level;
    wire [1:0] detected_level;

    // Level encoding
    assign detected_level = s[2] ? 2'b11 :    // Above s[2]
                           s[1] ? 2'b10 :    // Between s[2]-s[1]
                           s[0] ? 2'b01 :    // Between s[1]-s[0]
                                  2'b00;     // Below s[0]

    // Flow rate outputs
    always @(*) begin
        case(detected_level)
            2'b00: {fr2, fr1, fr0} = 3'b111;  // Below s[0]
            2'b01: {fr2, fr1, fr0} = 3'b011;  // Between s[1]-s[0]
            2'b10: {fr2, fr1, fr0} = 3'b001;  // Between s[2]-s[1]
            2'b11: {fr2, fr1, fr0} = 3'b000;  // Above s[2]
        endcase
    end

    // Rising edge detection and history
    always @(posedge clk) begin
        if (reset) begin
            current_level <= 2'b00;
            prev_level <= 2'b00;
            dfr <= 1'b1;
        end else begin
            prev_level <= current_level;
            current_level <= detected_level;
            
            // Pulse dfr for one cycle when level rises
            dfr <= (current_level > prev_level);
        end
    end

endmodule