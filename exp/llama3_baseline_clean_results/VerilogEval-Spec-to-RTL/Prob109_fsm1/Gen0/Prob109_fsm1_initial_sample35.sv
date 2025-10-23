module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [1:0] current_state; // Using 2 bits for two states (A=2'b01, B=2'b10)
reg [1:0] next_state;

// Define states
parameter STATE_A = 2'b01;
parameter STATE_B = 2'b10;

always @(*) begin
    case (current_state)
        STATE_B: begin
            if (in == 1'b0) begin
                next_state = STATE_A;
            end else begin
                next_state = STATE_B;
            end
        end
        STATE_A: begin
            if (in == 1'b0) begin
                next_state = STATE_B;
            end else begin
                next_state = STATE_A;
            end
        end
        default: next_state = STATE_B; // Default state if current_state is not recognized
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= STATE_B;
    end else begin
        current_state <= next_state;
    end
end

// Output logic based on current state
always @(*) begin
    case (current_state)
        STATE_B: out = 1'b1;
        STATE_A: out = 1'b0;
        default: out = 1'b0; // Default output if current_state is not recognized
    endcase
end

endmodule