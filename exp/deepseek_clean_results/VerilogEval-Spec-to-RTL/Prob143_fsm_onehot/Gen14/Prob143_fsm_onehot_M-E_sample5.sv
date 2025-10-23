module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Priority encoder to handle multiple active states (though one-hot should have only one)
wire [3:0] current_state_idx;
priority_encoder pe (
    .in(state),
    .out(current_state_idx)
);

// Pre-calculate all possible next states
wire [9:0] next_S0 = {1'b1, 9'b0};  // Default transition
wire [9:0] next_S1 = in ? 10'b0000000010 : 10'b0000000001;
wire [9:0] next_S2 = in ? 10'b0000000100 : 10'b0000000001;
wire [9:0] next_S3 = in ? 10'b0000001000 : 10'b0000000001;
wire [9:0] next_S4 = in ? 10'b0000010000 : 10'b0000000001;
wire [9:0] next_S5 = in ? 10'b0000100000 : 10'b0001000000;
wire [9:0] next_S6 = in ? 10'b0001000000 : 10'b0010000000;
wire [9:0] next_S7 = in ? 10'b0001000000 : 10'b0000000001;
wire [9:0] next_S8 = in ? 10'b0000000010 : 10'b0000000001;
wire [9:0] next_S9 = in ? 10'b0000000010 : 10'b0000000001;

// Select next state based on current state
always @(*) begin
    case (current_state_idx)
        4'd0: next_state = next_S0;
        4'd1: next_state = next_S1;
        4'd2: next_state = next_S2;
        4'd3: next_state = next_S3;
        4'd4: next_state = next_S4;
        4'd5: next_state = next_S5;
        4'd6: next_state = next_S6;
        4'd7: next_state = next_S7;
        4'd8: next_state = next_S8;
        4'd9: next_state = next_S9;
        default: next_state = next_S0;
    endcase
end

// Output generation - check if in output-producing states
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

endmodule

// Priority encoder submodule
module priority_encoder (
    input [9:0] in,
    output reg [3:0] out
);
always @(*) begin
    casez (in)
        10'b1?????????: out = 4'd9;
        10'b01????????: out = 4'd8;
        10'b001???????: out = 4'd7;
        10'b0001??????: out = 4'd6;
        10'b00001?????: out = 4'd5;
        10'b000001????: out = 4'd4;
        10'b0000001???: out = 4'd3;
        10'b00000001??: out = 4'd2;
        10'b000000001?: out = 4'd1;
        10'b0000000001: out = 4'd0;
        default: out = 4'd0;
    endcase
end
endmodule