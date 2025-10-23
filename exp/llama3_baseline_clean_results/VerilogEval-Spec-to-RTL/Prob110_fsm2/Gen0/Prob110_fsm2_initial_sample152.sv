module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [1:0] state;  // Using 2 bits for 2 states: OFF and ON
reg [1:0] next_state;

// State encoding: OFF = 2'b00, ON = 2'b01
parameter OFF = 2'b00;
parameter ON  = 2'b01;

always @(*) begin
    case(state)
        OFF: begin
            if(j == 1'b1) next_state = ON;
            else next_state = OFF;
        end
        ON: begin
            if(k == 1'b1) next_state = OFF;
            else next_state = ON;
        end
        default: next_state = OFF;
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) state <= OFF;
    else state <= next_state;
end

always @(*) begin
    case(state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule