module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] state, nextState;
reg prev_s0, prev_s1, prev_s2;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000; // Reset to state equivalent to water level below s[0]
        prev_s0 <= 1'b0;
        prev_s1 <= 1'b0;
        prev_s2 <= 1'b0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        state <= nextState;
        prev_s0 <= s[0];
        prev_s1 <= s[1];
        prev_s2 <= s[2];
        
        case (state)
            3'b000: begin // Water level below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            3'b001: begin // Water level between s[1] and s[0]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prev_s0 == 1'b0 && s[0] == 1'b1);
            end
            3'b010: begin // Water level between s[2] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (prev_s1 == 1'b0 && s[1] == 1'b1) || (prev_s0 == 1'b0 && s[0] == 1'b1);
            end
            3'b011: begin // Water level above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
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

always @(*) begin
    case ({s[2], s[1], s[0]})
        3'b111: nextState = 3'b011; // Water level above s[2]
        3'b110, 3'b111: nextState = 3'b010; // Water level between s[2] and s[1]
        3'b100, 3'b101, 3'b110, 3'b111: nextState = 3'b001; // Water level between s[1] and s[0]
        default: nextState = 3'b000; // Water level below s[0]
    endcase
end

endmodule