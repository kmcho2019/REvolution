module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        current_state <= 2'b01; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        2'b01: begin // State A
            if (x) begin
                next_state = 2'b10; // Move to state B
                z = 1'b1;
            end else begin
                next_state = 2'b01; // Stay in state A
                z = 1'b0;
            end
        end
        2'b10: begin // State B
            next_state = 2'b10; // Stay in state B
            z = x ? 1'b0 : 1'b1;
        end
        default: begin
            next_state = 2'b01; // Default to state A
            z = 1'b0;
        end
    endcase
end

endmodule