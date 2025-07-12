module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Priority encoder to determine the highest priority request
reg [1:0] priority;

always @(*) begin
    case (r)
        3'b001: priority = 2'b11;  // Device 2 has the highest priority
        3'b010: priority = 2'b10;  // Device 1 has the highest priority
        3'b100: priority = 2'b01;  // Device 0 has the highest priority
        default: priority = 2'b00;  // No requests
    endcase
end

// State machine to manage the granting of access
reg [0:0] current_state;
reg [0:0] next_state;

always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 1'b0;  // Reset to IDLE state
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        1'b0:  // IDLE state
            if (r!= 3'b000) begin
                next_state = 1'b1;  // Transition to GRANT state
            end else begin
                next_state = 1'b0;  // Stay in IDLE state
            end
        1'b1:  // GRANT state
            if (r == 3'b000) begin
                next_state = 1'b0;  // Transition back to IDLE state
            end else begin
                next_state = 1'b1;  // Stay in GRANT state
            end
        default:
            next_state = 1'b0;  // Default to IDLE state
    endcase
end

// Output logic to generate grant signals
always @(*) begin
    case (priority)
        2'b11: g = 3'b001;  // Grant access to device 2
        2'b10: g = 3'b010;  // Grant access to device 1
        2'b01: g = 3'b100;  // Grant access to device 0
        default: g = 3'b000;  // No grants
    endcase
end

endmodule