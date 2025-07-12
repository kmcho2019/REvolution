module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] current_level;
reg [1:0] prev_level;

// Priority encoder to determine current water level
always @(s) begin
    casez (s)
        3'b111: current_level = 2'b00; // ABOVE
        3'b110, 3'b101, 3'b100: current_level = 2'b01; // BETWEEN_HIGH_MIDDLE
        3'b011, 3'b010: current_level = 2'b10; // BETWEEN_MIDDLE_LOW
        default: current_level = 2'b11; // BELOW
    endcase
end

// Sequential logic to track previous water level and control flow rate
always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_level <= 2'b11; // BELOW
    end else begin
        prev_level <= current_level;
        case (current_level)
            2'b00: begin // ABOVE
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            2'b01: begin // BETWEEN_HIGH_MIDDLE
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (current_level > prev_level);
            end
            2'b10: begin // BETWEEN_MIDDLE_LOW
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (current_level > prev_level);
            end
            2'b11: begin // BELOW
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase
    end
end

endmodule