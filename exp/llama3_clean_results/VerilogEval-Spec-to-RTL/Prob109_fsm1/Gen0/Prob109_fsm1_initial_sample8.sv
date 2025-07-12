module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states
localparam STATE_A = 1'b0;
localparam STATE_B = 1'b1;

// Declare the state register
reg current_state;
reg next_state;

// Asynchronous reset to state B
always @(posedge areset or posedge clk) begin
    if (areset) begin
        current_state <= STATE_B;
    end else begin
        current_state <= next_state;
    end
end

// State transitions
always @(*) begin
    case (current_state)
        STATE_A: begin
            if (in == 1'b0) begin
                next_state = STATE_B;
                out = 1'b0;
            end else begin
                next_state = STATE_A;
                out = 1'b0;
            end
        end
        STATE_B: begin
            if (in == 1'b0) begin
                next_state = STATE_A;
                out = 1'b1;
            end else begin
                next_state = STATE_B;
                out = 1'b1;
            end
        end
    endcase
end

endmodule