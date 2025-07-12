module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [1:0] state = 2'b00; // 2 states: OFF (00), ON (01)
reg [1:0] next_state;

localparam OFF = 2'b00;
localparam ON  = 2'b01;

always @(*) begin
    case(state)
        OFF: next_state = (j) ? ON : OFF;
        ON:  next_state = (k) ? OFF : ON;
        default: next_state = OFF;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule