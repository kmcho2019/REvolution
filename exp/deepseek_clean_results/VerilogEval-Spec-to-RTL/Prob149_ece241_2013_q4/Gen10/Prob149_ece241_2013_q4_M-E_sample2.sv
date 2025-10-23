module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Encoded water levels
    localparam BELOW_ALL = 2'b00;
    localparam ABOVE_S0  = 2'b01;
    localparam ABOVE_S1  = 2'b10;
    localparam ABOVE_S2  = 2'b11;

    reg [1:0] curr_level, prev_level;

    // Priority encoder for sensor inputs
    always @(*) begin
        casex (s)
            3'b000: curr_level = BELOW_ALL;
            3'bxx1: curr_level = ABOVE_S0;
            3'b1x0: curr_level = ABOVE_S1;
            3'b010: curr_level = ABOVE_S1;
            default: curr_level = ABOVE_S2;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} <= 4'b1111;
            prev_level <= BELOW_ALL;
        end else begin
            prev_level <= curr_level;

            // Nominal flow outputs based on current level
            case (curr_level)
                BELOW_ALL: {fr2, fr1, fr0} = 3'b111;
                ABOVE_S0:  {fr2, fr1, fr0} = 3'b011;
                ABOVE_S1:  {fr2, fr1, fr0} = 3'b001;
                ABOVE_S2:  {fr2, fr1, fr0} = 3'b000;
            endcase

            // Detect rising water level (current > previous)
            dfr <= (curr_level > prev_level);
        end
    end

endmodule