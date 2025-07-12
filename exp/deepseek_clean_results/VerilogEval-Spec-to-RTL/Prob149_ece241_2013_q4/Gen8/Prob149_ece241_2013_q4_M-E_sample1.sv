module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Water level encoding
    wire [1:0] current_level;
    reg [1:0] prev_level;

    // Priority encoder for water level detection
    assign current_level = (s[2]) ? 2'b00 :    // Above s[2]
                          (s[1]) ? 2'b01 :    // Between s[2]-s[1]
                          (s[0]) ? 2'b10 :    // Between s[1]-s[0]
                          2'b11;              // Below s[0]

    // History tracking and reset
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'b11;  // Initialize to below s[0]
        end else begin
            prev_level <= current_level;
        end
    end

    // Output logic
    assign fr0 = (current_level != 2'b00);  // On for any level except above s[2]
    assign fr1 = (current_level >= 2'b10);  // On for mid-low and below
    assign fr2 = (current_level == 2'b11);  // On only for below s[0]

    // Supplemental flow when level is rising (current > previous)
    assign dfr = (current_level < prev_level);

endmodule