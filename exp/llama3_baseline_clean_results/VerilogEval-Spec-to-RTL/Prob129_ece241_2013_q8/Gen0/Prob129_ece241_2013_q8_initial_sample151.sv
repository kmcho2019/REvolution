module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state; // 0: S0, 1: S1, 2: S2
reg [1:0] next_state;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= 0;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        0: begin // S0
            if (x) begin
                next_state = 1; // Move to S1 if x is 1
            end else begin
                next_state = 0; // Stay in S0 if x is 0
            end
        end
        1: begin // S1
            if (x) begin
                next_state = 1; // Stay in S1 if x is 1
            end else begin
                next_state = 2; // Move to S2 if x is 0
            end
        end
        2: begin // S2
            if (x) begin
                next_state = 1; // Move to S1 if x is 1
            end else begin
                next_state = 0; // Move to S0 if x is 0
            end
        end
        default: next_state = 0;
    endcase
end

assign z = (state == 2 && x); // Assert z when in S2 and x is 1

endmodule