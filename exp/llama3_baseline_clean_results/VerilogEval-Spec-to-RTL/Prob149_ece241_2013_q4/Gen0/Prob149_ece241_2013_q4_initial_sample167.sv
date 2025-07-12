module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s,  // s[2] is the highest sensor, s[0] is the lowest sensor
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [1:0] prev_level;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        prev_level <= 2'b00;  // Below s[0]
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Determine the current water level
        reg [1:0] curr_level;
        if (s[2]) begin
            curr_level <= 2'b11;  // Above s[2]
        end else if (s[1]) begin
            curr_level <= 2'b10;  // Between s[1] and s[2]
        end else if (s[0]) begin
            curr_level <= 2'b01;  // Between s[0] and s[1]
        end else begin
            curr_level <= 2'b00;  // Below s[0]
        end

        // Update the previous water level
        prev_level <= curr_level;

        // Determine the flow rate
        case (curr_level)
            2'b11: begin  // Above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            2'b10: begin  // Between s[1] and s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (prev_level == 2'b11 || prev_level == 2'b10) begin
                    dfr <= 1'b0;
                end else begin
                    dfr <= 1'b1;
                end
            end
            2'b01: begin  // Between s[0] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (prev_level == 2'b01 || prev_level == 2'b10) begin
                    dfr <= 1'b0;
                end else begin
                    dfr <= 1'b1;
                end
            end
            2'b00: begin  // Below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase
    end
end

endmodule