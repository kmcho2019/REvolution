module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

reg [1:0] next_state;

// Combinational next state logic
always @(*) begin
    case (state)
        2'b00: begin
            if (train_valid && train_taken)
                next_state = 2'b01;
            else if (train_valid && !train_taken)
                next_state = 2'b00; // saturate
            else
                next_state = state;
        end
        2'b01: begin
            if (train_valid && train_taken)
                next_state = 2'b10;
            else if (train_valid && !train_taken)
                next_state = 2'b00;
            else
                next_state = state;
        end
        2'b10: begin
            if (train_valid && train_taken)
                next_state = 2'b11;
            else if (train_valid && !train_taken)
                next_state = 2'b01;
            else
                next_state = state;
        end
        2'b11: begin
            if (train_valid && train_taken)
                next_state = 2'b11; // saturate
            else if (train_valid && !train_taken)
                next_state = 2'b10;
            else
                next_state = state;
        end
        default: next_state = 2'b01; // default to weakly not-taken
    endcase
end

// Sequential state register with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule