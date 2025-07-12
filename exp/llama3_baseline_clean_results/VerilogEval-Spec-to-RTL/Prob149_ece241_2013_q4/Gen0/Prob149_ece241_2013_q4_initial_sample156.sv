module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] state; // state register
reg [2:0] nextState; // next state register
reg [2:0] prev_state; // previous state register

always @(*) begin
    // Determine next state based on current state and inputs
    case(state)
        3'b000: // below s[0]
            if (s[0] == 1'b1) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b000;
            end
        3'b001: // between s[0] and s[1]
            if (s[1] == 1'b1) begin
                nextState = 3'b010;
            end else if (s[0] == 1'b0) begin
                nextState = 3'b000;
            end else begin
                nextState = 3'b001;
            end
        3'b010: // between s[1] and s[2]
            if (s[2] == 1'b1) begin
                nextState = 3'b011;
            end else if (s[1] == 1'b0) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b010;
            end
        3'b011: // above s[2]
            if (s[2] == 1'b0) begin
                nextState = 3'b010;
            end else begin
                nextState = 3'b011;
            end
        default: nextState = 3'b000;
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
        state <= 3'b000; // reset to below s[0] state
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        state <= nextState;
        // Determine outputs based on current state
        case(state)
            3'b000: // below s[0]
                begin
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end
            3'b001: // between s[0] and s[1]
                begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= (prev_state == 3'b000); // increase flow rate if previous state was below s[0]
                end
            3'b010: // between s[1] and s[2]
                begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= (prev_state == 3'b001); // increase flow rate if previous state was between s[0] and s[1]
                end
            3'b011: // above s[2]
                begin
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
        prev_state <= state;
    end
end

endmodule