module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

// Define one-hot encoded states
reg [1:0] state, next_state;

// Define sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // walking left
    end else begin
        state <= next_state;
    end
end

// Define combinational logic
always_comb begin
    case (state)
        2'b01: begin // walking left
            if (bump_left) begin
                next_state = 2'b10; // walking right
            end else begin
                next_state = 2'b01; // walking left
            end
        end
        2'b10: begin // walking right
            if (bump_right) begin
                next_state = 2'b01; // walking left
            end else begin
                next_state = 2'b10; // walking right
            end
        end
        default: begin
            next_state = 2'b01; // walking left
        end
    endcase

    // Handle outputs
    case (state)
        2'b01: begin // walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        2'b10: begin // walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
    endcase
end

endmodule