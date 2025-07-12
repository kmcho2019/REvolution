module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

always @(*) begin
    case(current_state)
        2'b10: // State A
            begin
                if(x == 0) begin
                    next_state = 2'b10; // Stay in A
                    z = 1'b0;
                end else begin
                    next_state = 2'b01; // Go to B
                    z = 1'b1;
                end
            end
        2'b01: // State B
            begin
                next_state = 2'b01; // Stay in B
                z = 1'b1;
            end
        default: // This should not happen, but for completeness
            begin
                next_state = 2'b10; // Go to A
                z = 1'b0;
            end
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= 2'b10; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

endmodule