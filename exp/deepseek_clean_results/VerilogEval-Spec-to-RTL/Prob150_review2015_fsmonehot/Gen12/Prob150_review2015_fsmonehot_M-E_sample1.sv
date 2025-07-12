module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // Original one-hot encoding preserved for interface
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Hierarchical state encoding
wire [2:0] h_state = {state[4]|state[5]|state[6]|state[7],  // Shift superstate
                     state[0]|state[1]|state[2]|state[3],  // Detect superstate
                     state[8]|state[9]};                   // Count/Wait

// Precompute common conditions
wire d_rising = d & (state[0] | state[1] | state[2] | state[3]);
wire d_falling = ~d & (state[0] | state[1] | state[2] | state[3]);

// Next state logic using hierarchical encoding
assign S_next = (h_state == 3'b010 && d_falling) ||  // Detect->S on d=0
                (h_state == 3'b000 && ack);          // Wait->S on ack=1

assign S1_next = (h_state == 3'b010 && state[0] && d); // S->S1 on d=1

assign B3_next = (h_state == 3'b100 && state[6]);     // B2->B3

assign Count_next = (h_state == 3'b100 && state[7]) ||  // B3->Count
                    (h_state == 3'b001 && ~done_counting); // Count stay

assign Wait_next = (h_state == 3'b001 && done_counting) || // Count->Wait
                   (h_state == 3'b000 && ~ack);            // Wait stay

// Output logic with pipelining
reg shift_ena_reg;
always @(*) begin
    shift_ena_reg = (h_state == 3'b100);  // Shift superstate
end
assign shift_ena = shift_ena_reg;

reg counting_reg;
always @(*) begin
    counting_reg = (h_state == 3'b001);   // Count state
end
assign counting = counting_reg;

reg done_reg;
always @(*) begin
    done_reg = (h_state == 3'b000);       // Wait state
end
assign done = done_reg;

endmodule