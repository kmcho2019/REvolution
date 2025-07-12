module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;  // Previous sensor state

    always @(posedge clk) begin
        if (reset) begin
            // Reset state: all outputs high (maximum flow)
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
            prev_s <= 3'b000;  // Assume was below s[0]
        end else begin
            // Store previous sensor state
            prev_s <= s;

            // Flow rate outputs
            fr0 <= ~s[2];  // On unless above s[2]
            fr1 <= (s == 3'b001) || (s == 3'b000);  // Between s[1]-s[0] or below
            fr2 <= (s == 3'b000);  // Only when below s[0]

            // DFR (supplemental flow) when water is rising
            casex ({prev_s, s})
                6'b000_001,  // Below->Between s[1]-s[0]
                6'b000_011,  // Below->Between s[2]-s[1]
                6'b000_111,   // Below->Above s[2]
                6'b001_011,   // Between s[1]-s[0]->Between s[2]-s[1]
                6'b001_111,    // Between s[1]-s[0]->Above s[2]
                6'b011_111:    // Between s[2]-s[1]->Above s[2]
                    dfr <= 1'b1;
                default:
                    dfr <= 1'b0;
            endcase
        end
    end

endmodule