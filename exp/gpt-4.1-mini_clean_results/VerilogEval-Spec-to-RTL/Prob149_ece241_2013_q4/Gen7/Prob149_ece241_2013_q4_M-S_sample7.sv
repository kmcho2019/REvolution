module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water level encoding
    // 2'b00 = Below s[0]   (000)
    // 2'b01 = Between s[1] and s[0] (001)
    // 2'b10 = Between s[2] and s[1] (011)
    // 2'b11 = Above s[2]   (111)
    reg [1:0] prev_level, curr_level;

    always @(*) begin
        case (s)
            3'b000: curr_level = 2'b00; // Below s[0]
            3'b001: curr_level = 2'b01; // Between s[1] and s[0]
            3'b011: curr_level = 2'b10; // Between s[2] and s[1]
            3'b111: curr_level = 2'b11; // Above s[2]
            default: curr_level = 2'b00; // Treat others as below s[0]
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'b00;  // Low water level at reset
            dfr        <= 1'b1;   // Supplemental flow valve on reset
        end else begin
            dfr        <= (curr_level > prev_level) ? 1'b1 : 1'b0;
            prev_level <= curr_level;
        end
    end

    always @(*) begin
        case (curr_level)
            2'b11: begin // Above s[2]
                fr0 = 1'b0;
                fr1 = 1'b0;
                fr2 = 1'b0;
            end
            2'b10: begin // Between s[2] and s[1]
                fr0 = 1'b1;
                fr1 = 1'b0;
                fr2 = 1'b0;
            end
            2'b01: begin // Between s[1] and s[0]
                fr0 = 1'b1;
                fr1 = 1'b1;
                fr2 = 1'b0;
            end
            2'b00: begin // Below s[0]
                fr0 = 1'b1;
                fr1 = 1'b1;
                fr2 = 1'b1;
            end
            default: begin // Safe default (should not occur)
                fr0 = 1'b1;
                fr1 = 1'b1;
                fr2 = 1'b1;
            end
        endcase
    end

endmodule