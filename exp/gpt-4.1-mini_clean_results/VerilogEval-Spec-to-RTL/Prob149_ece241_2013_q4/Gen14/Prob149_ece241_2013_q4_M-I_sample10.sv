module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water levels encoding
    localparam BELOW    = 2'd0; // No sensors asserted: s=3'b000
    localparam BETWEEN0 = 2'd1; // Only lowest sensor asserted: s=3'b001
    localparam BETWEEN1 = 2'd2; // Lowest and middle sensors asserted: s=3'b011
    localparam ABOVE    = 2'd3; // All sensors asserted: s=3'b111

    // Decode sensor pattern exactly
    wire is_above    = (s == 3'b111);
    wire is_between1 = (s == 3'b011);
    wire is_between0 = (s == 3'b001);
    wire is_below    = (s == 3'b000);

    // Default to BELOW for any unexpected pattern
    wire [1:0] next_level = is_above    ? ABOVE    :
                           is_between1 ? BETWEEN1 :
                           is_between0 ? BETWEEN0 :
                           is_below    ? BELOW    :
                                         BELOW;

    reg [1:0] curr_level;
    reg [1:0] prev_level;

    // Sequential logic to update levels and outputs synchronously
    always @(posedge clk) begin
        if (reset) begin
            curr_level <= BELOW;
            prev_level <= BELOW;
            fr0       <= 1'b1;
            fr1       <= 1'b1;
            fr2       <= 1'b1;
            dfr       <= 1'b1;
        end else begin
            if (next_level != curr_level) begin
                prev_level <= curr_level;
                curr_level <= next_level;
            end else begin
                // No change, levels stay the same
                prev_level <= prev_level;
                curr_level <= curr_level;
            end

            // Assign nominal flow outputs based on curr_level
            case (next_level)
                ABOVE: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN1: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN0: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                BELOW: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // dfr asserted when water level rises (prev_level < curr_level)
            dfr <= (next_level > curr_level) ? 1'b1 : 1'b0;
        end
    end

endmodule