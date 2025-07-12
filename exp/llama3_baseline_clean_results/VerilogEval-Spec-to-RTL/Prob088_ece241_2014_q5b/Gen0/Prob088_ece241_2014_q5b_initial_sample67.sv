module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b10;  // Reset to state A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b10: begin  // State A
            if (x == 1'b0) begin
                next_state = 2'b10;  // Stay in state A
                z = 1'b0;
            end else begin
                next_state = 2'b01;  // Go to state B
                z = 1'b1;
            end
        end
        2'b01: begin  // State B
            if (x == 1'b0) begin
                next_state = 2'b01;  // Stay in state B
                z = 1'b1;
            end else begin
                next_state = 2'b01;  // Stay in state B
                z = 1'b0;
            end
        end
        default: begin
            next_state = 2'b10;  // Default to state A
            z = 1'b0;
        end
    endcase
end

endmodule