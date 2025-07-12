module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Category detection wires
wire is_reset    = state[0];
wire is_counting = |state[4:1];
wire is_special  = |state[6:5];
wire is_output   = |state[9:7];

// Output logic - direct from output states
assign out1 = state[8] | state[9];
assign out2 = state[7] | state[9];

// Parallel transition logic for each category
wire [9:0] reset_trans    = is_reset    ? {9'b0, ~in, in} : 10'b0;
wire [9:0] counting_trans = is_counting ? {state[4] & in,  // S5
                                          state[3] & in,  // S4
                                          state[2] & in,  // S3
                                          state[1] & in,  // S2
                                          5'b0,
                                          ~in} : 10'b0;
wire [9:0] special_trans  = is_special  ? {state[6] & in,  // S7
                                          state[5] & in,  // S6
                                          3'b0,
                                          state[6] & ~in,  // S9
                                          state[5] & ~in,  // S8
                                          2'b0} : 10'b0;
wire [9:0] output_trans   = is_output   ? {state[7] & in,  // S7 self-loop
                                          2'b0,
                                          ~in,  // S0
                                          in,   // S1
                                          5'b0} : 10'b0;

// Priority-based state resolution
always @(*) begin
    next_state = 10'b0;
    if (is_output) begin
        next_state = output_trans;
    end else if (is_special) begin
        next_state = special_trans;
    end else if (is_counting) begin
        next_state = counting_trans | reset_trans;
    end else begin
        next_state = reset_trans;
    end
end

endmodule