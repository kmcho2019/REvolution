module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

// Define states using one-hot encoding
reg [4:0] state; // 5 states: idle, s1, s2, s3, s4

// State transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 5'b10000; // Reset to idle state
    end else begin
        case (state)
            5'b10000: // Idle state
                if (IN) begin
                    state <= 5'b01000; // Transition to s1
                end else begin
                    state <= 5'b10000; // Stay in idle state
                end
            5'b01000: // State s1
                if (!IN) begin
                    state <= 5'b00100; // Transition to s2
                end else begin
                    state <= 5'b10000; // Reset to idle state
                end
            5'b00100: // State s2
                if (!IN) begin
                    state <= 5'b00010; // Transition to s3
                end else begin
                    state <= 5'b10000; // Reset to idle state
                end
            5'b00010: // State s3
                if (IN) begin
                    state <= 5'b00001; // Transition to s4
                end else begin
                    state <= 5'b10000; // Reset to idle state
                end
            5'b00001: // State s4
                if (IN) begin
                    state <= 5'b00001; // Stay in s4 (match detected)
                end else begin
                    state <= 5'b10000; // Reset to idle state
                end
            default: state <= 5'b10000; // Reset to idle state
        endcase
    end
end

// Combinational logic for match signal
assign MATCH = (state == 5'b00001)? 1'b1 : 1'b0;

endmodule