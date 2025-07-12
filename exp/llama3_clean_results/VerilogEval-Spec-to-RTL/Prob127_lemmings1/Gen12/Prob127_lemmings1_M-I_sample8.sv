module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

// Enumerate states using one-hot encoding
typedef enum {LEFT, RIGHT} state_t;

reg [1:0] state;

// Define sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Initialize to LEFT state
    end else begin
        case (state)
            2'b01: begin // LEFT state
                if (bump_left) begin
                    state <= 2'b10; // Switch to RIGHT state
                end
            end
            2'b10: begin // RIGHT state
                if (bump_right) begin
                    state <= 2'b01; // Switch to LEFT state
                end
            end
        endcase
    end
end

// Define outputs
assign walk_left = (state == 2'b01);
assign walk_right = (state == 2'b10);

endmodule