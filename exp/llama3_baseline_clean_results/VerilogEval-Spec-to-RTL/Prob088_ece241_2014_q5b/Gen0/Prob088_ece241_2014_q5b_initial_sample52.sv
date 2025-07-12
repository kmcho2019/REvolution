module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= next_state;
    end
end

always @* begin
    case(state)
        2'b01: begin // State A
            if (~x) begin
                next_state = 2'b01; // Stay in A if x = 0
                z = 1'b0;
            end else begin
                next_state = 2'b10; // Go to B if x = 1
                z = 1'b1;
            end
        end
        2'b10: begin // State B
            if (~x) begin
                next_state = 2'b10; // Stay in B if x = 0
                z = 1'b1;
            end else begin
                next_state = 2'b10; // Stay in B if x = 1
                z = 1'b0;
            end
        end
        default: begin
            next_state = 2'b01; // Default to state A
            z = 1'b0;
        end
    endcase
end

endmodule