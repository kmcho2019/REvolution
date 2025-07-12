module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// One-hot state definitions
localparam [3:0]
    IDLE   = 4'b0001,
    GOT1   = 4'b0010,
    GOT10  = 4'b0100,
    GOT100 = 4'b1000;

reg [3:0] state, next_state;
wire clk_gated;
reg clk_en;

// Clock gating logic
assign clk_gated = clk_en ? CLK : 1'b0;

// State transition and clock enable logic
always @(*) begin
    clk_en = 1'b1;  // Default to enabled
    next_state = state;  // Default to stay in current state
    
    case (1'b1)  // Synopsys parallel_case
        state[0]: begin // IDLE
            clk_en = IN;  // Only enable clock if we get a '1'
            next_state = IN ? GOT1 : IDLE;
        end
        state[1]: begin // GOT1
            next_state = IN ? GOT1 : GOT10;
        end
        state[2]: begin // GOT10
            next_state = IN ? GOT1 : GOT100;
        end
        state[3]: begin // GOT100
            next_state = IN ? GOT1 : GOT10;
        end
    endcase
end

// Output logic (combinational)
always @(*) begin
    MATCH = (state == GOT100) & IN;
end

// State register with gated clock
always @(posedge clk_gated or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule