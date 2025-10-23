module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state, next_state;
localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0;
        z <= 1'b0;
    end else begin
        state <= next_state;
        if (next_state == S2 && x == 1'b1) begin
            z <= 1'b1;
        end else if (next_state == S1 && x == 1'b1) begin
            z <= 1'b0;
        end else if (next_state == S0 && x == 1'b1) begin
            z <= 1'b0;
        end else begin
            z <= 1'b0;
        end
    end
end

always @* begin
    case(state)
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
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x == 1'b1) begin
                next_state = S2;
                z = 1'b1;
            end else begin
                next_state = S1;
            end
        end
    endcase
end

endmodule