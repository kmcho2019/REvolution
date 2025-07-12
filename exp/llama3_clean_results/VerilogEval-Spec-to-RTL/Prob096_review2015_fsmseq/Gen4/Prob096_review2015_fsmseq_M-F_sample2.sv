module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Define states using binary encoding
reg [1:0] state; // IDLE, SEEN_1, SEEN_11, SEEN_110, SEEN_1101
wire [1:0] next_state;

// Combinational next state logic
always @(*) begin
    case (state)
        2'b00: begin // IDLE state
            if (data == 1) begin
                next_state = 2'b01; // transition to SEEN_1 state
            end else begin
                next_state = 2'b00; // stay in IDLE state
            end
        end
        2'b01: begin // SEEN_1 state
            if (data == 1) begin
                next_state = 2'b10; // transition to SEEN_11 state
            end else begin
                next_state = 2'b00; // transition back to IDLE state
            end
        end
        2'b10: begin // SEEN_11 state
            if (data == 0) begin
                next_state = 2'b11; // transition to SEEN_110 state
            end else begin
                next_state = 2'b10; // stay in SEEN_11 state
            end
        end
        2'b11: begin // SEEN_110 state
            if (data == 1) begin
                next_state = 2'b01; // transition to SEEN_1 state ( actual correct next state for 1101 sequence)
            end else begin
                next_state = 2'b00; // transition back to IDLE state
            end
        end
        default: next_state = 2'b00; // default to IDLE state
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // reset to IDLE state
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == 2'b01 && data == 1) begin
            start_shifting <= 1;
        end else if (reset) begin
            start_shifting <= 0;
        end
    end
end

endmodule