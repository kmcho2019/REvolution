module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // State register with one-hot encoding
reg [1:0] next_state; // Next state register

// Define one-hot encoding for states
parameter STATE_A = 2'b01;
parameter STATE_B = 2'b10;

always @(*) begin
    case(state)
        STATE_A: begin
            if (x == 0) begin
                next_state = STATE_A;
                z = 0;
            end else begin
                next_state = STATE_B;
                z = 1;
            end
        end
        STATE_B: begin
            if (x == 0) begin
                next_state = STATE_B;
                z = 1;
            end else begin
                next_state = STATE_B;
                z = 0;
            end
        end
        default: begin
            next_state = STATE_A; // Default state
            z = 0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_A; // Asynchronous reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule