module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define state codes
reg [1:0] state;
reg [1:0] next_state;

// Priority encoder
always @(*) begin
    case (1'b1)
        r[0]: next_state = 2'b01; // State B
        r[1]: next_state = 2'b10; // State C
        r[2]: next_state = 2'b11; // State D
        default: next_state = 2'b00; // State A
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to State A
    end else if (state == 2'b01 && r[0] == 1'b0) begin
        state <= 2'b00; // Transition from State B to State A
    end else if (state == 2'b10 && r[1] == 1'b0) begin
        state <= 2'b00; // Transition from State C to State A
    end else if (state == 2'b11 && r[2] == 1'b0) begin
        state <= 2'b00; // Transition from State D to State A
    end else begin
        state <= next_state;
    end
end

// FSM outputs
assign g[0] = (state == 2'b01); // g[0] is 1 in State B
assign g[1] = (state == 2'b10); // g[1] is 1 in State C
assign g[2] = (state == 2'b11); // g[2] is 1 in State D

endmodule