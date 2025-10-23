module TopModule (
    input        clk,
    input        areset,
    input        j,
    input        k,
    output       out
);

reg [0:0] state; // 1-bit state variable
reg [0:0] next_state; // 1-bit next state variable

// Output logic
assign out = (state == 1'b1);

// Next state logic
always @(*) begin
    case (state)
        1'b0: next_state = (j == 1'b1) ? 1'b1 : 1'b0;
        1'b1: next_state = (k == 1'b1) ? 1'b0 : 1'b1;
        default: next_state = 1'b0;
    endcase
end

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0;
    end else begin
        state <= next_state;
    end
end

endmodule