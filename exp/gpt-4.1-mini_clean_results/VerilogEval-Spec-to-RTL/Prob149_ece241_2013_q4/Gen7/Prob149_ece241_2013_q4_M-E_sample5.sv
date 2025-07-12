module TopModule (
    input         clk,
    input         reset,
    input  [2:0]  s,
    output reg    fr2,
    output reg    fr1,
    output reg    fr0,
    output reg    dfr
);

// Water level states encoded as 2-bit values for easy numeric comparison
localparam BELOW_S0      = 2'd0;
localparam BETWEEN_S1_S0 = 2'd1;
localparam BETWEEN_S2_S1 = 2'd2;
localparam ABOVE_S2      = 2'd3;

reg [1:0] current_level;
reg [1:0] previous_level;

// Function to decode sensor inputs into water level state
// According to problem sensor patterns:
// 111 => ABOVE_S2
// 011 => BETWEEN_S2_S1
// 001 => BETWEEN_S1_S0
// 000 => BELOW_S0
// All other patterns map to closest valid state:
// Priority: if s[0]==1 => BETWEEN_S1_S0
// else BELOW_S0
function [1:0] decode_level(input [2:0] sens);
begin
    case (sens)
        3'b111: decode_level = ABOVE_S2;
        3'b011: decode_level = BETWEEN_S2_S1;
        3'b001: decode_level = BETWEEN_S1_S0;
        3'b000: decode_level = BELOW_S0;
        default: begin
            if (sens[0] == 1'b1) 
                decode_level = BETWEEN_S1_S0;
            else 
                decode_level = BELOW_S0;
        end
    endcase
end
endfunction

// Synchronous FSM state updates and previous level tracking
always @(posedge clk) begin
    if (reset) begin
        current_level  <= BELOW_S0;
        previous_level <= BELOW_S0;
        // Outputs are assigned after this block below
    end else begin
        previous_level <= current_level;
        current_level  <= decode_level(s);
    end
end

// Output logic: synchronous with clock
always @(posedge clk) begin
    if (reset) begin
        // On reset, max flow: all valves open including supplemental
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Nominal flow valves per level:
        // ABOVE_S2: fr0=fr1=fr2=0
        // BETWEEN_S2_S1: fr0=1, fr1=0, fr2=0
        // BETWEEN_S1_S0: fr0=1, fr1=1, fr2=0
        // BELOW_S0: fr0=1, fr1=1, fr2=1
        case (current_level)
            ABOVE_S2: begin
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            BETWEEN_S2_S1: begin
                fr0 <= 1'b1;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            BETWEEN_S1_S0: begin
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b0;
            end
            BELOW_S0: begin
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b1;
            end
            default: begin
                // Safe default: full flow
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b1;
            end
        endcase
        
        // Supplemental flow valve dfr asserted if level increased and level is not ABOVE_S2
        // level increase = current_level > previous_level numerically
        if ((current_level > previous_level) && (current_level != ABOVE_S2))
            dfr <= 1'b1;
        else
            dfr <= 1'b0;
    end
end

endmodule