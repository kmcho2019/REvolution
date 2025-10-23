module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        current_state <= 2'b00;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        2'b00: begin // S0
            if (x) begin
                next_state = 2'b01; // Transition to S1 on '1'
                z = 1'b0;
            end else begin
                next_state = 2'b00; // Stay in S0 on '0'
                z = 1'b0;
            end
        end
        2'b01: begin // S1
            if (x) begin
                next_state = 2'b01; // Stay in S1 on '1'
                z = 1'b0;
            end else begin
                next_state = 2'b10; // Transition to S2 on '0'
                z = 1'b0;
            end
        end
        2'b10: begin // S2
            if (x) begin
                next_state = 2'b01; // Transition to S1 on '1', overlapping sequence detected
                z = 1'b1; // Assert z on '1' after '10'
            end else begin
                next_state = 2'b00; // Transition to S0 on '0'
                z = 1'b0;
            end
        end
        default: begin
            next_state = 2'b00;
            z = 1'b0;
        end
    endcase
end

endmodule