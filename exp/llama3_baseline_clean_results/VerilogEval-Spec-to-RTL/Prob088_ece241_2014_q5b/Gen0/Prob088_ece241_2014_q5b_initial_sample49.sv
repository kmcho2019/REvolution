module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

// Define the one-hot encoded states
reg [1:0] state;
reg [1:0] next_state;

// Define the states
parameter STATE_A = 2'b01;
parameter STATE_B = 2'b10;

// Reset logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_A;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        STATE_A: begin
            if (x == 1'b0) begin
                next_state = STATE_A;
                z = 1'b0;
            end else begin
                next_state = STATE_B;
                z = 1'b1;
            end
        end
        STATE_B: begin
            if (x == 1'b0) begin
                next_state = STATE_B;
                z = 1'b1;
            end else begin
                next_state = STATE_B;
                z = 1'b0;
            end
        end
        default: begin
            next_state = STATE_A;
            z = 1'b0;
        end
    endcase
end

endmodule