module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// One-hot encoded states for better timing
parameter IDLE    = 4'b0001;
parameter GOT1    = 4'b0010;
parameter GOT10   = 4'b0100;
parameter GOT100  = 4'b1000;

reg [3:0] current_state, next_state;
reg IN_prev;
wire IN_changed = IN != IN_prev;

// Clock gating logic
wire state_clk_en = IN_changed || (current_state != next_state);
wire gated_clk = CLK & state_clk_en;

// State transition and output logic
always @(posedge gated_clk or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        IN_prev <= 1'b0;
    end else begin
        current_state <= next_state;
        IN_prev <= IN;
    end
end

// Next state and output logic (combinational)
always @(*) begin
    MATCH = 1'b0;
    case (current_state)
        IDLE: begin
            next_state = IN ? GOT1 : IDLE;
        end
        GOT1: begin
            next_state = IN ? GOT1 : GOT10;
        end
        GOT10: begin
            next_state = IN ? GOT1 : GOT100;
        end
        GOT100: begin
            MATCH = IN;  // Output assigned combinationally
            next_state = IN ? GOT1 : GOT10;
        end
    endcase
end

endmodule