module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Priority-encoded water level
    reg [1:0] current_level;
    reg [1:0] prev_level;
    reg [2:0] prev_s;

    // Edge detection registers
    wire level_changed;
    wire rising_edge;

    // Priority encoder for current water level
    always @(*) begin
        casez (s)
            3'b1??: current_level = 2'b11; // Above s[2]
            3'b01?: current_level = 2'b10; // Between s[2] and s[1]
            3'b001: current_level = 2'b01; // Between s[1] and s[0]
            3'b000: current_level = 2'b00; // Below s[0]
            default: current_level = 2'b00; // Fallback
        endcase
    end

    // State tracking and edge detection
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'b00;
            prev_s <= 3'b000;
        end else begin
            prev_level <= current_level;
            prev_s <= s;
        end
    end

    // Transition detection
    assign level_changed = (current_level != prev_level);
    assign rising_edge = level_changed && (current_level > prev_level);

    // Output generation (combinational)
    assign fr0 = reset ? 1'b1 : (current_level <= 2'b10);
    assign fr1 = reset ? 1'b1 : (current_level <= 2'b01);
    assign fr2 = reset ? 1'b1 : (current_level == 2'b00);
    assign dfr = reset ? 1'b1 : (rising_edge && !level_changed);

endmodule