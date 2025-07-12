module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s, // s[2], s[1], s[0]
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] currentState;

// State Encoding:
// 3'b000: Below s[0]
// 3'b001: Between s[1] and s[0]
// 3'b010: Between s[2] and s[1]
// 3'b011: Above s[2]

always @ (posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to if the water level had been low for a long time
        currentState <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (s)
            3'b000: currentState <= 3'b000; // Below s[0]
            3'b001: currentState <= 3'b001; // Between s[1] and s[0]
            3'b011: currentState <= 3'b010; // Between s[2] and s[1]
            3'b111: currentState <= 3'b011; // Above s[2]
            default: currentState <= currentState; // Stay in current state
        endcase
    end
end

always @ (posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (currentState)
            3'b000: begin // Below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end
            3'b001: begin // Between s[1] and s[0]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (s == 3'b001 && (s[0]!= s[1] || s[0]!= s[2])) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            3'b010: begin // Between s[2] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (s == 3'b011 && (s[0]!= s[1] || s[0]!= s[2])) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            3'b011: begin // Above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            default: begin
                fr2 <= fr2;
                fr1 <= fr1;
                fr0 <= fr0;
                dfr <= dfr;
            end
        endcase
    end
end
endmodule