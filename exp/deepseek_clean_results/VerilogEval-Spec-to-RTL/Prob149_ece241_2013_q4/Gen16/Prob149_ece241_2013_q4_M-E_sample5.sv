module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Current and previous sensor states
    reg [2:0] prev_s;
    wire [2:0] sensor_edges = s ^ prev_s;

    // Water level rising detection
    wire level_rising = (s > prev_s);

    // Output generation
    always @(posedge clk) begin
        if (reset) begin
            // Reset to below s[0] state
            {fr2, fr1, fr0} <= 3'b111;
            dfr <= 1'b1;
            prev_s <= 3'b000;
        end else begin
            // Store previous sensor state
            prev_s <= s;

            // Default outputs (below s[0] case)
            {fr2, fr1, fr0} <= 3'b111;
            dfr <= 1'b0;

            // Handle other water level cases
            case (s)
                3'b111: begin  // Above s[2]
                    {fr2, fr1, fr0} <= 3'b000;
                end
                3'b011: begin  // Between s[2] and s[1]
                    {fr2, fr1, fr0} <= 3'b001;
                end
                3'b001: begin  // Between s[1] and s[0]
                    {fr2, fr1, fr0} <= 3'b011;
                end
                3'b000: begin  // Below s[0] (handled by default)
                end
                default: begin // Handle partial or invalid states
                    {fr2, fr1, fr0} <= 3'b000;
                end
            endcase

            // Supplemental flow when water is rising (except when above s[2])
            dfr <= level_rising && (s != 3'b111);
        end
    end

endmodule