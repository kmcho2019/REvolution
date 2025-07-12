module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

localparam IDLE = 2'b00;  // no match
localparam S1   = 2'b01;  // matched '1'
localparam S2   = 2'b10;  // matched "11"
localparam DET  = 2'b11;  // detected "1101", latched

reg [1:0] state, next_state;

always @(posedge clk) begin
    if (reset)
        state <= IDLE;
    else
        state <= next_state;
end

always @(*) begin
    case (state)
        IDLE: next_state = data ? S1 : IDLE;
        S1:   next_state = data ? S2 : IDLE;
        S2:   next_state = data ? S2 : DET;  // if data=0, next bit should be 0, but check sequence: 1101
        DET:  next_state = DET; // latch in detected state
        default: next_state = IDLE;
    endcase
end

assign start_shifting = (state == DET);

endmodule