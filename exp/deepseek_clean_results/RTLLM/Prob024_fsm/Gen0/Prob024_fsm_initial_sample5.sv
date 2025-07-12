module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

    // Define states
    parameter IDLE   = 3'b000;
    parameter S1     = 3'b001;
    parameter S10    = 3'b010;
    parameter S100   = 3'b011;
    parameter S1001  = 3'b100;
    parameter S10011 = 3'b101;

    reg [2:0] current_state, next_state;

    // State transition logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= IDLE;
            MATCH <= 1'b0;
        end else begin
            current_state <= next_state;
            // MATCH is 1 only when transitioning from S1001 to S10011 with IN=1
            MATCH <= (current_state == S1001) && (IN == 1'b1) ? 1'b1 : 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                next_state = (IN == 1'b1) ? S1 : IDLE;
            end
            S1: begin
                next_state = (IN == 1'b0) ? S10 : S1;
            end
            S10: begin
                next_state = (IN == 1'b0) ? S100 : S1;
            end
            S100: begin
                next_state = (IN == 1'b1) ? S1001 : IDLE;
            end
            S1001: begin
                next_state = (IN == 1'b1) ? S10011 : S10;
            end
            S10011: begin
                next_state = (IN == 1'b1) ? S1 : S10;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule