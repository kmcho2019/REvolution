module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Define water level states
    localparam ABOVE_S2  = 2'b11;
    localparam S2_TO_S1  = 2'b10;
    localparam S1_TO_S0  = 2'b01;
    localparam BELOW_S0  = 2'b00;

    reg [1:0] current_level;
    reg [1:0] prev_level;

    // Level detection (priority encoded)
    always @(*) begin
        if (s[2]) current_level = ABOVE_S2;
        else if (s[1]) current_level = S2_TO_S1;
        else if (s[0]) current_level = S1_TO_S0;
        else current_level = BELOW_S0;
    end

    // Output logic
    always @(*) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} = 4'b1111;
        end else begin
            case (current_level)
                ABOVE_S2:  {fr2, fr1, fr0} = 3'b000;
                S2_TO_S1: {fr2, fr1, fr0} = 3'b001;
                S1_TO_S0: {fr2, fr1, fr0} = 3'b011;
                BELOW_S0: {fr2, fr1, fr0} = 3'b111;
            endcase
            
            // dfr is 1 if water is rising and not at highest level
            dfr = (current_level > prev_level) && (current_level != ABOVE_S2);
        end
    end

    // State update
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= BELOW_S0;
        end else begin
            prev_level <= current_level;
        end
    end

endmodule