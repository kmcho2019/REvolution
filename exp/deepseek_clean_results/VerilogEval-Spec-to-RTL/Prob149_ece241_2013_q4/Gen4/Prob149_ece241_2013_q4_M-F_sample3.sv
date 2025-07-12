module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Determine current water level zone
    wire [1:0] current_zone;
    assign current_zone = s[2] ? 2'b00 :       // Above s[2]
                         s[1] ? 2'b01 :       // Between s[2]-s[1]
                         s[0] ? 2'b10 :       // Between s[1]-s[0]
                         2'b11;               // Below s[0]

    // Store previous sensor state for transition detection
    reg [2:0] prev_s;
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;  // Start as if coming from below
        end else begin
            prev_s <= s;
        end
    end

    // Determine previous zone for transition comparison
    wire [1:0] prev_zone;
    assign prev_zone = prev_s[2] ? 2'b00 :
                      prev_s[1] ? 2'b01 :
                      prev_s[0] ? 2'b10 :
                      2'b11;

    // Output generation (registered)
    always @(posedge clk) begin
        if (reset) begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Nominal flow rates
            case (current_zone)
                2'b00: {fr2, fr1, fr0} <= 3'b000;  // Above s[2]
                2'b01: {fr2, fr1, fr0} <= 3'b001;  // Between s[2]-s[1]
                2'b10: {fr2, fr1, fr0} <= 3'b011;  // Between s[1]-s[0]
                2'b11: {fr2, fr1, fr0} <= 3'b111;  // Below s[0]
            endcase

            // Supplemental flow if previous level was lower
            dfr <= (current_zone < prev_zone);
        end
    end

endmodule