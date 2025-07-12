module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state; // S0 (2'b00), S1 (2'b01), S2 (2'b10)
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b00: begin // S0
            if(x == 1'b1) next_state = 2'b01; // Seen '1', move to S1
            else next_state = 2'b00; // Stay in S0
        end
        2'b01: begin // S1
            if(x == 1'b0) next_state = 2'b10; // Seen '10', move to S2
            else next_state = 2'b01; // Stay in S1
        end
        2'b10: begin // S2
            if(x == 1'b1) next_state = 2'b01; // Seen '101', move back to S1
            else next_state = 2'b00; // Reset to S0
        end
        default: next_state = 2'b00;
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if(~aresetn) state <= 2'b00; // Asynchronous reset
    else state <= next_state;
end

assign z = (state == 2'b10 && x == 1'b1); // Assert z when '101' is detected

endmodule