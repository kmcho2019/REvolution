module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // 2 bits for 3 states (S0, S1, S2)
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b00: // S0
            if(x) begin
                next_state = 2'b01; // transition to S1
                z = 1'b0;
            end else begin
                next_state = 2'b00; // stay in S0
                z = 1'b0;
            end
        2'b01: // S1
            if(x) begin
                next_state = 2'b01; // stay in S1 (not part of '101' sequence)
                z = 1'b0;
            end else begin
                next_state = 2'b10; // transition to S2
                z = 1'b0;
            end
        2'b10: // S2
            if(x) begin
                next_state = 2'b01; // transition back to S1 (detected '101')
                z = 1'b1;
            end else begin
                next_state = 2'b10; // stay in S2
                z = 1'b0;
            end
        default: begin
            next_state = 2'b00;
            z = 1'b0;
        end
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if(~aresetn) begin
        state <= 2'b00; // reset to S0
    end else begin
        state <= next_state;
    end
end

endmodule