module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state; // 2 bits for 3 states (S0, S1, S2)
reg [1:0] next_state;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= 2'b00; // reset to S0
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // S0
            if (x) begin
                next_state = 2'b01; // transition to S1
            end else begin
                next_state = 2'b00; // stay in S0
            end
            z = 1'b0; // deassert z
        end
        2'b01: begin // S1
            if (~x) begin
                next_state = 2'b10; // transition to S2
            end else begin
                next_state = 2'b01; // stay in S1
            end
            z = 1'b0; // deassert z
        end
        2'b10: begin // S2
            if (x) begin
                next_state = 2'b00; // transition to S0 and assert z
                z = 1'b1; // assert z
            end else begin
                next_state = 2'b10; // stay in S2
                z = 1'b0; // deassert z
            end
        end
        default: begin
            next_state = 2'b00; // default to S0
            z = 1'b0; // deassert z
        end
    endcase
end

endmodule