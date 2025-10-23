module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state;
localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

always @(negedge aresetn) begin
    state <= S0;
    z <= 1'b0;
end

always @(posedge clk) begin
    case(state)
        S0: begin
            if(x) begin
                state <= S1;
            end else begin
                state <= S0;
            end
            z <= 1'b0;
        end
        S1: begin
            if(x) begin
                state <= S1;
                z <= 1'b1;
            end else begin
                state <= S2;
            end
        end
        S2: begin
            if(x) begin
                state <= S1;
                z <= 1'b1;
            end else begin
                state <= S0;
            end
        end
    endcase
end

endmodule