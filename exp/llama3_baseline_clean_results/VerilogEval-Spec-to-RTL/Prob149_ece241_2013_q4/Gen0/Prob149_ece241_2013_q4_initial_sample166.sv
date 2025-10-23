module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s, // 3-bit sensor input
    output reg fr2, // Nominal flow valve 2
    output reg fr1, // Nominal flow valve 1
    output reg fr0, // Nominal flow valve 0
    output reg dfr  // Supplemental flow valve
);

always @(posedge clk) begin
    if (reset) begin // Active-high synchronous reset
        fr2 <= 1'b1; // All nominal flow valves open
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1; // Supplemental flow valve open
    end else begin
        case ({s[2], s[1], s[0]}) // Determine current state
            3'b111: begin // Above s[2]
                fr2 <= 1'b0; // No nominal flow valves open
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0; // Supplemental flow valve closed
            end
            3'b011: begin // Between s[2] and s[1]
                fr2 <= 1'b0; // Only fr0 open
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= 1'b0; // Supplemental flow valve closed
            end
            3'b001: begin // Between s[1] and s[0]
                fr2 <= 1'b0; // fr0 and fr1 open
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0; // Supplemental flow valve closed
            end
            default: begin // Below s[0]
                fr2 <= 1'b1; // All nominal flow valves open
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1; // Supplemental flow valve open
            end
        endcase
    end
end

endmodule