module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;
parameter S6 = 3'b110;
parameter S7 = 3'b111;

reg [2:0] state, next_state;

always @(*) begin
    case(state)
        S0: begin
            if(in) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if(in) next_state = S2;
            else next_state = S0;
        end
        S2: begin
            if(in) next_state = S3;
            else next_state = S0;
        end
        S3: begin
            if(in) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            if(in) next_state = S5;
            else next_state = S0;
        end
        S5: begin
            if(in) next_state = S6;
            else next_state = S0;
        end
        S6: begin
            if(in) next_state = S7;
            else next_state = S0;
        end
        S7: begin
            next_state = S7;
        end
        default: next_state = S0;
    endcase
end

always @(posedge clk) begin
    if(reset) state <= S0;
    else state <= next_state;
end

assign disc = (state == S5);
assign flag = (state == S6);
assign err = (state == S7);

endmodule