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

    // Combinational logic for next level
    wire [1:0] next_level = 
        (s == 3'b000) ? BELOW_S0 :    // Below s[0]
        (s == 3'b001) ? S0_S1 :       // Between s[0] and s[1]
        (s == 3'b011) ? S1_S2 :       // Between s[1] and s[2]
        ABOVE_S2;                     // Above s[2]

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset to maximum flow state (all outputs high)
            current_level <= BELOW_S0;
            prev_level <= BELOW_S0;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Update previous level before changing current level
            prev_level <= current_level;
            current_level <= next_level;
            
            // Update outputs based on new state
            case (next_level)
                BELOW_S0: begin
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                S0_S1: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                S1_S2: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                end
                ABOVE_S2: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
            endcase
            
            // dfr is 1 when water level is rising (current > previous)
            dfr <= (next_level > current_level);
        end
    end

endmodule