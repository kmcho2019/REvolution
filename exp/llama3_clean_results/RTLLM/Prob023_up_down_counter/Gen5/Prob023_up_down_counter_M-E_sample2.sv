module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [1:0] state;  // State machine states: idle (0), incrementing (1), decrementing (2)

always @ (posedge clk) begin
    case (state)
        2'b00: begin  // Idle state
            if (reset) begin
                count <= 16'd0;
                state <= 2'b00;
            end else if (up_down) begin
                count <= count + 1;
                state <= 2'b01;
            end else begin
                count <= count - 1;
                state <= 2'b10;
            end
        end
        2'b01: begin  // Incrementing state
            if (reset) begin
                count <= 16'd0;
                state <= 2'b00;
            end else if (up_down) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
                state <= 2'b10;
            end
        end
        2'b10: begin  // Decrementing state
            if (reset) begin
                count <= 16'd0;
                state <= 2'b00;
            end else if (~up_down) begin
                count <= count - 1;
            end else begin
                count <= count + 1;
                state <= 2'b01;
            end
        end
    endcase
end

endmodule