module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define state codes
reg [1:0] state;
reg [1:0] next_state;

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00;  // Reset to state A
    end else begin
        state <= next_state;
    end
end

// State table
always @(*) begin
    case (state)
        2'b00:  // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01;  // Go to state B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10;  // Go to state C
            end else begin
                next_state = 2'b00;  // Stay in state A
            end
        2'b01:  // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01;  // Stay in state B
            end else begin
                next_state = 2'b00;  // Go back to state A
            end
        2'b10:  // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10;  // Stay in state C
            end else begin
                next_state = 2'b00;  // Go back to state A
            end
        default:
            next_state = 2'b00;  // Default to state A
    endcase
end

// Assign output signals g[0], g[1], and g[2] based on the current state and input signals
assign g[0] = (state == 2'b01) && r[0];  // g[0] is 1 in State B and r[0] is 1
assign g[1] = (state == 2'b10) && r[1];  // g[1] is 1 in State C and r[1] is 1
assign g[2] = (state == 2'b00) && r[2];  // g[2] is 1 in State A and r[2] is 1

endmodule