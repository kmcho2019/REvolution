module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg [1:0] state; // One-hot encoded state machine
reg [1:0] next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        state <= 2'b01; // Initial state: incrementing
    end else begin
        case (state)
            2'b01: begin // Incrementing state
                counter <= (counter == 31) ? 31 : counter + 1;
                if (counter == 31) state <= 2'b10; // Transition to decrementing state
            end
            2'b10: begin // Decrementing state
                counter <= (counter == 0) ? 0 : counter - 1;
                if (counter == 0) state <= 2'b01; // Transition to incrementing state
            end
        endcase
    end
end

assign wave = counter;

endmodule