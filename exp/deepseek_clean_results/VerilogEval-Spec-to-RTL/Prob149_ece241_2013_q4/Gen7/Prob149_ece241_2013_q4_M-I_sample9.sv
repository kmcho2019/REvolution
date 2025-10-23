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

    reg [1:0] current_level, prev_level;

    // Combinational level detection
    wire [1:0] level = (s == 3'b000) ? BELOW_S0 :
                       (s == 3'b001) ? S0_S1    :
                       (s == 3'b011) ? S1_S2    :
                       ABOVE_S2;

    always @(posedge clk) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} <= 4'b1111;
            current_level <= BELOW_S0;
            prev_level <= BELOW_S0;
        end else begin
            prev_level <= current_level;
            current_level <= level;

            // Nominal flow outputs (unchanged from working version)
            fr0 <= (level != ABOVE_S2);
            fr1 <= (level == BELOW_S0 || level == S0_S1);
            fr2 <= (level == BELOW_S0);

            // Supplemental flow - was previous level lower than current?
            dfr <= (prev_level < current_level);
        end
    end

endmodule