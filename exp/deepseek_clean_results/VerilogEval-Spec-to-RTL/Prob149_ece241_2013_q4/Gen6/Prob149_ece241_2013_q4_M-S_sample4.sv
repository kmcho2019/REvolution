module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;

    // Combinatorial output logic
    always @(*) begin
        case (s)
            3'b111: {fr2, fr1, fr0} = 3'b000;  // Above s[2]
            3'b011: {fr2, fr1, fr0} = 3'b001;  // Between s[2] and s[1]
            3'b001: {fr2, fr1, fr0} = 3'b011;  // Between s[1] and s[0]
            default: {fr2, fr1, fr0} = 3'b111; // Below s[0] or invalid
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;  // Reset to below s[0] state
            dfr <= 1'b1;      // All outputs high
        end else begin
            // Detect rising water (current sensors show higher level than previous)
            dfr <= (s > prev_s);
            prev_s <= s;
        end
    end

endmodule