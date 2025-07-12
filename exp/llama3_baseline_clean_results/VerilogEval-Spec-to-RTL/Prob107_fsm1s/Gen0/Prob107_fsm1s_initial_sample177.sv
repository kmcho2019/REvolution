module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state; // Using a single bit for two states
reg [0:0] next_state;

// Output logic
always @(state) begin
    case (state)
        1'b0: out = 1'b1; // State B
        1'b1: out = 1'b0; // State A
        default: out = 1'b0;
    endcase
end

// Next state logic
always @(*) begin
    case (state)
        1'b0: begin // State B
            if (in == 1'b0) next_state = 1'b1;
            else next_state = 1'b0;
        end
        1'b1: begin // State A
            if (in == 1'b0) next_state = 1'b0;
            else next_state = 1'b1;
        end
        default: next_state = 1'b0;
    endcase
end

// State register
always @(posedge clk) begin
    if (reset) state <= 1'b0; // Reset to state B
    else state <= next_state;
end

endmodule