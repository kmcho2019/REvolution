module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] current_state, next_state;
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

always @(*) begin
    case(current_state)
        S0: begin
            if(x) next_state = S1;
            else next_state = S0;
            z = 1'b0;
        end
        S1: begin
            if(x) next_state = S1;
            else next_state = S2;
            z = 1'b0;
        end
        S2: begin
            if(x) begin
                next_state = S1;
                z = 1'b1;
            end
            else begin
                next_state = S0;
                z = 1'b0;
            end
        end
        default: begin
            next_state = S0;
            z = 1'b0;
        end
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if(~aresetn) begin
        current_state <= S0;
    end
    else begin
        current_state <= next_state;
    end
end

endmodule