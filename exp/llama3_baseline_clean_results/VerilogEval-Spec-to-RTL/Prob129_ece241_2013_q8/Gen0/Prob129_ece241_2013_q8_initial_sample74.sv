module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] nextState;

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case(state)
        S0: begin
            if(x) begin
                nextState = S1;
            end else begin
                nextState = S0;
            end
        end
        S1: begin
            if(~x) begin
                nextState = S2;
            end else begin
                nextState = S1;
            end
        end
        S2: begin
            if(x) begin
                nextState = S1;
            end else begin
                nextState = S0;
            end
        end
        default: begin
            nextState = S0;
        end
    endcase
end

assign z = (state == S2) && x;

endmodule