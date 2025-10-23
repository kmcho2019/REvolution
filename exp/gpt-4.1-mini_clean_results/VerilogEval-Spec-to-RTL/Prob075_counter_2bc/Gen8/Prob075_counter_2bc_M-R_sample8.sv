module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    wire increment = train_valid & train_taken;
    wire decrement = train_valid & ~train_taken;

    wire [1:0] next_state_unsat;

    // Calculate next_state with saturating increment/decrement using arithmetic
    assign next_state_unsat = state + increment - decrement;

    // Saturate next state between 0 and 3
    wire [1:0] next_state = (next_state_unsat > 2'd3) ? 2'd3 :
                            (next_state_unsat[1] & ~next_state_unsat[0] & decrement) ? 2'd0 : // handle wraparound below 0
                            next_state_unsat;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else begin
            state <= next_state;
        end
    end

endmodule