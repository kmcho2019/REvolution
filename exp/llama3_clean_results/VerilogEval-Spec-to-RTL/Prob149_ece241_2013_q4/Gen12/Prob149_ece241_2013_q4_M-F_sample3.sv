module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] prev_level;

always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_level <= 2'b00;
    end else begin
        reg [1:0] curr_level;
        
        // Determine the current water level based on the sensor inputs
        case (s)
            3'b000: curr_level = 2'b00; // Below s[0]
            3'b001: curr_level = 2'b01; // Between s[0] and s[1]
            3'b011: curr_level = 2'b10; // Between s[1] and s[2]
            3'b111: curr_level = 2'b11; // Above s[2]
            default: curr_level = prev_level; // Handle other cases by keeping the previous level
        endcase

        // Set the output signals based on the current water level
        case (curr_level)
            2'b00: begin // Below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            2'b01: begin // Between s[0] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            2'b10: begin // Between s[1] and s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            2'b11: begin // Above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
        endcase

        // Set the 'dfr' signal based on the change in water level
        dfr <= (curr_level > prev_level) ? 1'b1 : 1'b0;

        prev_level <= curr_level;
    end
end

endmodule