module TopModule(
    input  clk,
    input  reset,
    input  x,
    output z
);

// Define states
reg [2:0] current_state;
reg [2:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= 3'b000;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
        3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
        3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
        3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
        3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
        default: next_state = 3'b000; // Handle undefined states
    endcase
end

always @(*) begin
    case (current_state)
        3'b000, 3'b001, 3'b010: z = 1'b0;
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0; // Handle undefined states
    endcase
end

endmodule