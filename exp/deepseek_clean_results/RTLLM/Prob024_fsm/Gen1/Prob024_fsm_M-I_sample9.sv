module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// Binary state encoding
localparam [2:0] 
    IDLE  = 3'b000,
    S1    = 3'b001,
    S10   = 3'b010,
    S100  = 3'b011,
    S1001 = 3'b100;

reg [2:0] current_state, next_state;
reg next_match;

// State transition and output logic (combinational)
always @(*) begin
    next_state = current_state;
    next_match = 1'b0;
    
    case (current_state)
        IDLE: begin
            if (IN) next_state = S1;
        end
        S1: begin
            if (!IN) next_state = S10;
            else next_state = S1;
        end
        S10: begin
            if (!IN) next_state = S100;
            else next_state = IDLE;
        end
        S100: begin
            if (IN) next_state = S1001;
            else next_state = IDLE;
        end
        S1001: begin
            if (IN) begin
                next_match = 1'b1;
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
    endcase
end

// Sequential logic with clock gating for MATCH
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        // Only update MATCH when it might change
        if (current_state == S1001 || next_state == S1001)
            MATCH <= next_match;
        else
            MATCH <= 1'b0;
    end
end

endmodule