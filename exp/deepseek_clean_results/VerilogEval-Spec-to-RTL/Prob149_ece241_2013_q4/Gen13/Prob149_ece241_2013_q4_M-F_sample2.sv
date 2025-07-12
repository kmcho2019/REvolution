module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg [1:0] current_level, prev_level;

    // Encode current water level from sensors
    wire [1:0] level_encoding = 
        (s == 3'b000) ? 2'b00 :  // Below s[0]
        (s == 3'b001) ? 2'b01 :   // Between s[0]-s[1]
        (s == 3'b011) ? 2'b10 :   // Between s[1]-s[2]
        2'b11;                    // Above s[2] (111 or others)

    always @(posedge clk) begin
        if (reset) begin
            current_level <= 2'b00;  // Below s[0]
            prev_level <= 2'b00;
        end else begin
            prev_level <= current_level;
            current_level <= level_encoding;
        end
    end

    // Flow rate outputs
    assign fr0 = (reset) ? 1'b1 : (current_level != 2'b11);
    assign fr1 = (reset) ? 1'b1 : (current_level == 2'b01 || current_level == 2'b00);
    assign fr2 = (reset) ? 1'b1 : (current_level == 2'b00);

    // Supplemental flow (rising level or below s[0])
    assign dfr = (reset) ? 1'b1 : 
                ((current_level > prev_level) || (current_level == 2'b00));

endmodule