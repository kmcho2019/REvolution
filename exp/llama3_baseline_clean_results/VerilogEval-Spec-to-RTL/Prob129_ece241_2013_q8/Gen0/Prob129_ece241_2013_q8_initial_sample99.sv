module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state, next_state;

localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

always @(*) begin
    case(state)
        S0: begin
            if(x) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if(!x) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if(x) next_state = S1;
            else next_state = S0;
        end
        default: next_state = S0;
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if(!aresetn) state <= S0;
    else state <= next_state;
end

always @(*) begin
    case(state)
        S0: z = 1'b0;
        S1: z = 1'b0;
        S2: z = x;
        default: z = 1'b0;
    endcase
end

endmodule