module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] currentState;
reg [1:0] nextState;

always @(*) begin
    // Determine next state based on current state and sensor inputs
    case (currentState)
        2'b00: begin // Water level below s[0]
            if (s[0] == 1'b1) begin
                nextState = 2'b01; // Transition to State 1
            end else begin
                nextState = 2'b00; // Stay in State 0
            end
        end
        2'b01: begin // Water level between s[0] and s[1]
            if (s[1] == 1'b1) begin
                nextState = 2'b10; // Transition to State 2
            end else if (s[0] == 1'b0) begin
                nextState = 2'b00; // Transition to State 0
            end else begin
                nextState = 2'b01; // Stay in State 1
            end
        end
        2'b10: begin // Water level between s[1] and s[2]
            if (s[2] == 1'b1) begin
                nextState = 2'b11; // Transition to State 3
            end else if (s[1] == 1'b0) begin
                nextState = 2'b01; // Transition to State 1
            end else begin
                nextState = 2'b10; // Stay in State 2
            end
        end
        2'b11: begin // Water level above s[2]
            nextState = 2'b11; // Stay in State 3
        end
    endcase
end

always @(posedge clk) begin
    if (reset == 1'b1) begin
        currentState <= 2'b00; // Reset to State 0
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        currentState <= nextState;

        case (currentState)
            2'b00: begin // Water level below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            2'b01: begin // Water level between s[0] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if ((nextState == 2'b01) && (s[0] == 1'b1)) begin
                    dfr <= 1'b1; // Open Supplemental flow valve
                end else begin
                    dfr <= 1'b0;
                end
            end
            2'b10: begin // Water level between s[1] and s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if ((nextState == 2'b10) && (s[1] == 1'b1)) begin
                    dfr <= 1'b1; // Open Supplemental flow valve
                end else begin
                    dfr <= 1'b0;
                end
            end
            2'b11: begin // Water level above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule