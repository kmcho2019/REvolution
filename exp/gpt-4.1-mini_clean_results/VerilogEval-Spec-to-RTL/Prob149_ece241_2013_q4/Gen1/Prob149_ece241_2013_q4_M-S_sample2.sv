module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Encode regions numerically: BELOW=0, BETWEEN_1_0=1, BETWEEN_2_1=2, ABOVE=3
    reg [1:0] prev_region;

    reg [1:0] curr_region;

    always @(posedge clk) begin
        if (reset) begin
            // Reset state: water level low for long time
            prev_region <= 2'd0; // BELOW
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Determine current region based on sensor inputs
            if (s == 3'b111)
                curr_region = 2'd3; // ABOVE
            else if (s == 3'b011)
                curr_region = 2'd2; // BETWEEN s[2] and s[1]
            else if (s == 3'b001)
                curr_region = 2'd1; // BETWEEN s[1] and s[0]
            else if (s == 3'b000)
                curr_region = 2'd0; // BELOW s[0]
            else
                curr_region = 2'd0; // Treat other cases as BELOW (safe default)

            // Set nominal flow rate outputs based on current region
            case (curr_region)
                2'd3: begin // ABOVE s[2]
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd2: begin // BETWEEN s[2] and s[1]
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd1: begin // BETWEEN s[1] and s[0]
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                2'd0: begin // BELOW s[0]
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin // Defensive default
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // Supplemental flow valve open if water level rising (curr_region > prev_region)
            dfr <= (curr_region > prev_region) ? 1'b1 : 1'b0;

            prev_region <= curr_region;
        end
    end

endmodule