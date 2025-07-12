module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

localparam RESET_VALUE = 2'b01;  // Weakly not-taken

// Next state logic
reg [1:0] next_state;

always @(*) begin
    if (areset) begin
        next_state = RESET_VALUE;
    end
    else if (train_valid) begin
        // Arithmetic approach with saturation
        if (train_taken) begin
            next_state = (state == 2'b11) ? state : state + 1'b1;
        end
        else begin
            next_state = (state == 2'b00) ? state : state - 1'b1;
        end
    end
    else begin
        next_state = state;  // Hold current state when not training
    end
end

// Clock-gated state register
wire clk_gated = clk & (train_valid | areset);

always @(posedge clk_gated or posedge areset) begin
    if (areset)
        state <= RESET_VALUE;
    else
        state <= next_state;
end

endmodule