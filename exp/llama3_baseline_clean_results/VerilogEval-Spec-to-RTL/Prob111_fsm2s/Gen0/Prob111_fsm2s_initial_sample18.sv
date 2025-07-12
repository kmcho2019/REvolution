module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [0:0] state;
reg [0:0] next_state;

parameter OFF = 0;
parameter ON  = 1;

always @ (posedge clk) begin
    if(reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

always @ (*) begin
    case(state)
        OFF: if(j) next_state = ON; else next_state = OFF;
        ON:  if(k) next_state = OFF; else next_state = ON;
        default: next_state = OFF;
    endcase
end

always @ (*) begin
    case(state)
        OFF: out = 0;
        ON:  out = 1;
        default: out = 0;
    endcase
end

endmodule