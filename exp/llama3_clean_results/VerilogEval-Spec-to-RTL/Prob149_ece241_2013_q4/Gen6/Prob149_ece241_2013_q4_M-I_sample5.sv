module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prevState;

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prevState <= 3'b000; // Reset previous state
    end else begin
        // Determine output signals based on current sensor state
        case (s)
            3'b111: begin // Above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            3'b110: begin // Between s[2] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (prevState < s) ? 1'b1 : 1'b0;
            end
            3'b011: begin // Between s[1] and s[0]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prevState < s) ? 1'b1 : 1'b0;
            end
            3'b001: begin // Between s[0] and below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prevState < s) ? 1'b1 : 1'b0;
            end
            default: begin // Below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase
        
        // Update previous state
        prevState <= s;
    end
end

endmodule