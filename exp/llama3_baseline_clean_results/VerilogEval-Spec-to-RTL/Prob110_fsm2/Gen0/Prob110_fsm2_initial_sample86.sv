module TopModule(
    input       clk,
    input       areset,
    input       j,
    input       k,
    output reg  out
);

reg [1:0] state, next_state;

// Enum for states
localparam OFF = 2'b00;
localparam ON  = 2'b01;

always @(*) begin
    case(state)
        OFF: 
            if(j) next_state = ON;
            else next_state = OFF;
        ON: 
            if(k) next_state = OFF;
            else next_state = ON;
        default: next_state = OFF;
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule