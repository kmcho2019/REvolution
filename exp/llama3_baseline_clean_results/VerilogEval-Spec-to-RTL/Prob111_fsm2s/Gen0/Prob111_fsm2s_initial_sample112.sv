module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

parameter OFF = 1'b0;
parameter ON  = 1'b1;

reg current_state;
reg next_state;

always @(*) begin
    case(current_state)
        OFF: if(j) next_state = ON; else next_state = OFF;
        ON:  if(k) next_state = OFF; else next_state = ON;
        default: next_state = OFF;
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

assign out = current_state;

endmodule