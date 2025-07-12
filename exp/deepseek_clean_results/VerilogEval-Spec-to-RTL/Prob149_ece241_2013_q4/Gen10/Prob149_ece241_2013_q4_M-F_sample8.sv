module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Water level states
    localparam BELOW_S0 = 2'b00;
    localparam S0_S1    = 2'b01;
    localparam S1_S2    = 2'b10;
    localparam ABOVE_S2 = 2'b11;

    reg [1:0] current_level;
    reg [1:0] prev_level;

    // Determine current water level
    always @(*) begin
        case (s)
            3'b000: current_level = BELOW_S0;
            3'b001: current_level = S0_S1;
            3'b011: current_level = S1_S2;
            3'b111: current_level = ABOVE_S2;
            default: current_level = ABOVE_S2; // Handle other cases as above s[2]
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
            prev_level <= BELOW_S0;
        end else begin
            // Store previous level
            prev_level <= current_level;

            // Set flow rates based on current level
            case (current_level)
                BELOW_S0: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                S0_S1: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                S1_S2: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                ABOVE_S2: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
            endcase

            // Set dfr if current level is higher than previous
            dfr <= (current_level > prev_level);
        end
    end

endmodule