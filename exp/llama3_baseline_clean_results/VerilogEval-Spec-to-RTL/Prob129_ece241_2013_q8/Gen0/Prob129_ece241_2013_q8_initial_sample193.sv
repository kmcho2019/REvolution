module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state;
reg [1:0] nextState;

always @(*) begin
    case(state)
        2'b00: begin // S0
            if(x == 1'b1) begin
                nextState = 2'b01;
                z = 1'b0;
            end else begin
                nextState = 2'b00;
                z = 1'b0;
            end
        end
        2'b01: begin // S1
            if(x == 1'b0) begin
                nextState = 2'b10;
                z = 1'b0;
            end else if(x == 1'b1) begin
                nextState = 2'b01;
                z = 1'b0;
            end
        end
        2'b10: begin // S2
            if(x == 1'b1) begin
                nextState = 2'b01;
                z = 1'b1;
            end else begin
                nextState = 2'b00;
                z = 1'b0;
            end
        end
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        state <= 2'b00;
    end else begin
        state <= nextState;
    end
end

endmodule