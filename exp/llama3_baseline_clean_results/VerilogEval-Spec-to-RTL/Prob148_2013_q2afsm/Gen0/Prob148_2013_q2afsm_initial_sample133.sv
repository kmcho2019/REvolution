module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define state codes
reg [1:0] current_state;
reg [1:0] next_state;

// State table
always @(*) begin
    case (current_state)
        2'b00: // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // State B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // State C
            end else if (r[2] == 1'b1) begin
                next_state = 2'b00; // State A (priority not met)
            end else begin
                next_state = 2'b00; // State A (no requests)
            end
        2'b01: // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // State B
            end else begin
                next_state = 2'b00; // State A
            end
        2'b10: // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // State C
            end else begin
                next_state = 2'b00; // State A
            end
        default: // State D (not used)
            next_state = 2'b00; // State A
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 2'b00; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// Generate FSM outputs
always @(*) begin
    case (current_state)
        2'b00: // State A
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = 1'b0;
        2'b01: // State B
            g[0] = 1'b1;
            g[1] = 1'b0;
            g[2] = 1'b0;
        2'b10: // State C
            g[0] = 1'b0;
            g[1] = 1'b1;
            g[2] = 1'b0;
        default: // State D (not used)
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = 1'b0;
    endcase
end

endmodule