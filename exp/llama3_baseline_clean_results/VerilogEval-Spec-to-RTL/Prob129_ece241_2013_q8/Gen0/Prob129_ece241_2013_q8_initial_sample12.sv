module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] current_state, next_state;
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        S0: begin
            if (x == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (x == 1'b0) begin
                next_state = S2;
            end else if (x == 1'b1) begin
                next_state = S1;
            end
        end
        S2: begin
            if (x == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
    endcase
end

assign z = (current_state == S2 && x == 1'b1) || (current_state == S1 && x == 1'b0 && next_state == S2);

endmodule