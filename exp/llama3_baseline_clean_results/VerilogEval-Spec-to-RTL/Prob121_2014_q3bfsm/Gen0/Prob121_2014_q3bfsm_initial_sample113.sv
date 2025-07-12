module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] current_state, next_state;

// Output logic
always @(current_state) begin
    case (current_state)
        3'b000: z = 0;
        3'b001: z = 0;
        3'b010: z = 0;
        3'b011: z = 1;
        3'b100: z = 1;
        default: z = 0;
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= 3'b000;
    end else begin
        case (current_state)
            3'b000: current_state <= (x == 0) ? 3'b000 : 3'b001;
            3'b001: current_state <= (x == 0) ? 3'b001 : 3'b100;
            3'b010: current_state <= (x == 0) ? 3'b010 : 3'b001;
            3'b011: current_state <= (x == 0) ? 3'b001 : 3'b010;
            3'b100: current_state <= (x == 0) ? 3'b011 : 3'b100;
            default: current_state <= 3'b000;
        endcase
    end
end

endmodule