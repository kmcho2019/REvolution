module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [1:0] prevState;
reg [1:0] currState;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset to state below s[0]
        prevState <= 2'b00;
        currState <= 2'b00;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Determine current state based on sensor inputs
        casez ({s[2], s[1], s[0]})
            3'b111: currState <= 2'b11; // Above s[2]
            3'b011: currState <= 2'b10; // Between s[2] and s[1]
            3'b001: currState <= 2'b01; // Between s[1] and s[0]
            default: currState <= 2'b00; // Below s[0]
        endcase
        
        // Update previous state
        prevState <= currState;
        
        // Determine flow rate based on current state and previous state
        case (currState)
            2'b11: begin // Above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            2'b10: begin // Between s[2] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (prevState < currState) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            2'b01: begin // Between s[1] and s[0]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (prevState < currState) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            default: begin // Below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (prevState < currState) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
        endcase
    end
end

endmodule