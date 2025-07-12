module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
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
                next_state = 2'b11; // State D
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
        2'b11: // State D
            // Not used in this implementation
            next_state = 2'b00; // State A
        default:
            next_state = 2'b00; // State A
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 2'b00; // Reset to State A
    end else begin
        current_state <= next_state;
    end
end

// Output logic
always @(*) begin
    case (current_state)
        2'b00: // State A
            g <= 3'b000;
        2'b01: // State B
            g <= 3'b100;
        2'b10: // State C
            g <= 3'b010;
        2'b11: // State D
            g <= 3'b001;
        default:
            g <= 3'b000; // State A
    endcase
end

endmodule