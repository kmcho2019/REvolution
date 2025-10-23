module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] state;
reg [2:0] prev_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to state equivalent to low water level
        prev_state <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_state <= state;
        case (s)
            3'b111: state <= 3'b000; // Above s[2]
            3'b110: state <= 3'b001; // Between s[2] and s[1]
            3'b011: state <= 3'b010; // Between s[1] and s[0]
            3'b001: state <= 3'b010; // Between s[1] and s[0]
            3'b000: state <= 3'b011; // Below s[0]
            default: state <= 3'b000;
        endcase
        case (state)
            3'b000: begin // Above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            3'b001: begin // Between s[2] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (prev_state < state) ? 1'b1 : 1'b0;
            end
            3'b010: begin // Between s[1] and s[0]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prev_state < state) ? 1'b1 : 1'b0;
            end
            3'b011: begin // Below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            default: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule