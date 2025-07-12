module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state; // current state
reg [1:0] prev_state; // previous state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'd0; // reset to state 0
        prev_state <= 2'd0; // reset to state 0
        fr2 <= 1'b1; // all valves open
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (s)
            3'b000: begin // water level below s[0]
                state <= 2'd0;
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0; // supplemental valve off
            end
            3'b001: begin // water level between s[0] and s[1]
                state <= 2'd1;
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prev_state < state); // supplemental valve on if water level increasing
            end
            3'b011: begin // water level between s[1] and s[2]
                state <= 2'd2;
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (prev_state < state); // supplemental valve on if water level increasing
            end
            default: begin // water level above s[2]
                state <= 2'd3;
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0; // supplemental valve off
            end
        endcase
        prev_state <= state; // update previous state
    end
end

endmodule