module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] current_state; // 1 bit to represent states A (0) and B (1)
reg [0:0] next_state;

always @(*) begin
    case(current_state)
        1'b0: begin // State A
            if (in == 1'b1) begin
                next_state = 1'b0; // Stay in A if in is 1
            end else begin
                next_state = 1'b1; // Go to B if in is 0
            end
        end
        1'b1: begin // State B
            if (in == 1'b1) begin
                next_state = 1'b1; // Stay in B if in is 1
            end else begin
                next_state = 1'b0; // Go to A if in is 0
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b1; // Reset to state B
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        1'b0: out = 1'b0; // Output when in state A
        1'b1: out = 1'b1; // Output when in state B
    endcase
end

endmodule