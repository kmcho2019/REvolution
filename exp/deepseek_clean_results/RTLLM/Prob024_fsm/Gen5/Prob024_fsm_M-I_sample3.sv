module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// One-hot state encoding for better timing
localparam [4:0]
    IDLE  = 5'b00001,
    S1    = 5'b00010,
    S10   = 5'b00100,
    S100  = 5'b01000,
    S1001 = 5'b10000;

reg [4:0] state, next_state;
reg next_match;
wire clk_gate = (state != IDLE) && (state != S1) && (state != S10);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Clock-gated MATCH register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        MATCH <= 0;
    end else if (clk_gate) begin
        MATCH <= next_match;
    end
end

always @(*) begin
    next_state = state;
    next_match = 0;
    
    case (1'b1) // synthesis parallel_case
        state[0]: begin // IDLE
            next_state = IN ? S1 : IDLE;
        end
        state[1]: begin // S1
            next_state = IN ? S1 : S10;
        end
        state[2]: begin // S10
            next_state = IN ? IDLE : S100;
        end
        state[3]: begin // S100
            if (IN) begin
                next_state = S1001;
            end else begin
                next_state = IDLE;
            end
        end
        state[4]: begin // S1001
            next_match = IN;
            next_state = IN ? S1 : S10;
        end
    endcase
end

endmodule