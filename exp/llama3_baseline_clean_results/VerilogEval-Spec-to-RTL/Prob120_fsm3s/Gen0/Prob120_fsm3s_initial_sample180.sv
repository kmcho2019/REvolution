module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state;  // 2 bits to represent 4 states
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b00: begin  // State A
            if (!in) next_state = 2'b00;
            else next_state = 2'b01;
            out = 1'b0;
        end
        2'b01: begin  // State B
            if (!in) next_state = 2'b10;
            else next_state = 2'b01;
            out = 1'b0;
        end
        2'b10: begin  // State C
            if (!in) next_state = 2'b00;
            else next_state = 2'b11;
            out = 1'b0;
        end
        2'b11: begin  // State D
            if (!in) next_state = 2'b10;
            else next_state = 2'b01;
            out = 1'b1;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) state <= 2'b00;  // Reset to state A
    else state <= next_state;
end

endmodule