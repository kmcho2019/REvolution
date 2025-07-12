module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

// Define a Gray code-based state machine
reg [1:0] state;
reg [1:0] next_state;

// First stage: state transition logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Initialize state to LEFT
    end else begin
        case (state)
            2'b00: next_state <= (bump_left)? 2'b01 : 2'b00;
            2'b01: next_state <= (bump_right)? 2'b11 : 2'b01;
            2'b11: next_state <= (bump_left)? 2'b10 : 2'b11;
            2'b10: next_state <= (bump_right)? 2'b00 : 2'b10;
        endcase
        state <= next_state;
    end
end

// Second stage: output logic
always @(posedge clk) begin
    case (state)
        2'b00, 2'b10: begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end
        2'b01, 2'b11: begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
        end
    endcase
end

endmodule