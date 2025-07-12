module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Define region codes for clarity
    localparam BELOW = 2'd0;
    localparam BETWEEN_1_0 = 2'd1;
    localparam BETWEEN_2_1 = 2'd2;
    localparam ABOVE = 2'd3;

    reg [1:0] prev_region;
    reg [1:0] curr_region;

    always @(posedge clk) begin
        if (reset) begin
            prev_region <= BELOW;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Decode current region from sensor inputs (only exact matches as per spec)
            if (s == 3'b111)
                curr_region <= ABOVE;
            else if (s == 3'b011)
                curr_region <= BETWEEN_2_1;
            else if (s == 3'b001)
                curr_region <= BETWEEN_1_0;
            else if (s == 3'b000)
                curr_region <= BELOW;
            else
                curr_region <= BELOW; // default to BELOW if sensors assert other patterns

            // Assign nominal flow outputs based on region
            case (curr_region)
                ABOVE: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_2_1: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_1_0: begin
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

            // Supplemental flow valve dfr is 1 if water level rising (current region > previous region)
            dfr <= (curr_region > prev_region) ? 1'b1 : 1'b0;

            prev_region <= curr_region;
        end
    end

endmodule