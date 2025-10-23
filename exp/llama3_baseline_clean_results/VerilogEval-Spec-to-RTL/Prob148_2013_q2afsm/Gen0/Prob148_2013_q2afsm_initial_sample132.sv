module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] current_state;
reg [1:0] next_state;

// Describe the state table
always @(current_state, r) begin
    case (current_state)
        2'b00: // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // State B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // State C
            end else if (r[2] == 1'b1) begin
                next_state = 2'b11; // State D (not actually used)
            end else begin
                next_state = 2'b00; // State A
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
        default: // State D (not actually used)
            next_state = 2'b00; // State A
    endcase
end

// Describe the state flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 2'b00; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// Describe the FSM outputs
always @(current_state, r) begin
    case (current_state)
        2'b00: // State A
            g <= 3'b000;
        2'b01: // State B
            g <= 3'b100;
        2'b10: // State C
            g <= 3'b010;
        default: // State D (not actually used)
            g <= 3'b000;
    endcase
end

endmodule