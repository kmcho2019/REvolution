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

// Clock gating hint for synthesis
(* gated_clock = "yes" *) wire gated_clk;
assign gated_clk = CLK & (IN ^ current_state[0]); // Gate when IN matches IDLE state

// State transition and output logic
always @(posedge gated_clk or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state and output logic (Mealy style)
always @(*) begin
    MATCH = 1'b0; // Default output
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
            if (IN) begin
                next_state = GOT1;
                MATCH = 1'b1; // Output depends on current state AND input
            end else begin
                next_state = GOT10;
            end
        end
    endcase
end

endmodule