module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [0:0] current_state;  // 0: OFF, 1: ON
reg [0:0] next_state;

always @(*) begin
    case(current_state)
        0: begin  // State OFF
            if (j == 1'b1) begin
                next_state = 1'b1;  // Transition to ON if j is 1
            end else begin
                next_state = 1'b0;  // Stay in OFF if j is 0
            end
        end
        1: begin  // State ON
            if (k == 1'b1) begin
                next_state = 1'b0;  // Transition to OFF if k is 1
            end else begin
                next_state = 1'b1;  // Stay in ON if k is 0
            end
        end
        default: next_state = 1'b0;  // Default to OFF for any other state
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b0;  // Asynchronous reset to OFF
    end else begin
        current_state <= next_state;
    end
end

assign out = current_state;  // out is 1 in state ON, 0 in state OFF

endmodule