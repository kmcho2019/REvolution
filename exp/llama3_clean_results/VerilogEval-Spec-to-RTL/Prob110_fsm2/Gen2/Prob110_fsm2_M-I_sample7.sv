module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

// Using one-hot encoding for states
reg [1:0] state; // 2'b00: OFF, 2'b01: ON
reg [1:0] next_state;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 2'b00; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

// Next state logic using one-hot encoding
always @* begin
    case (state)
        2'b00: begin // OFF state
            if (j) begin
                next_state = 2'b01; // Transition to ON state
            end else begin
                next_state = 2'b00; // Stay in OFF state
            end
            out = 0;
        end
        2'b01: begin // ON state
            if (k) begin
                next_state = 2'b00; // Transition to OFF state
            end else begin
                next_state = 2'b01; // Stay in ON state
            end
            out = 1;
        end
        default: begin
            next_state = 2'b00; // Default to OFF state
            out = 0;
        end
    endcase
end

endmodule