module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot encoded states combined into 2-bit vector
// state[1] = state_B, state[0] = state_A (one-hot)
reg [1:0] state;
reg [1:0] next_state;

// Clock enable signal - active when state transition is required
wire clk_en;

// Next state logic (combinational)
always @(*) begin
    case (state)
        2'b01: begin // state A
            if (x)
                next_state = 2'b10; // go to B
            else
                next_state = 2'b01; // stay in A
        end
        2'b10: begin // state B
            next_state = 2'b10; // stay in B regardless of x
        end
        default: begin
            next_state = 2'b01; // default to A for safety
        end
    endcase
end

// Output logic (Mealy FSM): combinational
always @(*) begin
    case (state)
        2'b01: z = x ? 1'b1 : 1'b0;    // from A
        2'b10: z = (~x) ? 1'b1 : 1'b0; // from B
        default: z = 1'b0;
    endcase
end

// Clock enable asserted if state changes, else low to save power toggling
assign clk_en = (state != next_state);

// State registers with asynchronous active-high reset and clock gating
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // reset to state A
    end else if (clk_en) begin
        state <= next_state;
    end
end

endmodule