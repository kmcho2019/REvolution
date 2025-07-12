module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // Reduced state bits using one-hot encoding isn't necessary here due to simplicity
// We use a 2-bit state to reduce area and keep track of sequence detection
// State 0: Initial state, sequence not detected
// State 1: Sequence '11' detected
// State 2: Sequence '110' detected
// State 3: Sequence '1101' detected (and start_shifting is set to 1)

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // Reset to initial state
        start_shifting <= 0; // Reset start_shifting signal
    end else begin
        case(state)
            2'b00: begin // Initial state
                if(data == 1'b1) begin
                    state <= 2'b01; // Move to '11' detected state
                end
            end
            2'b01: begin // '11' detected
                if(data == 1'b1) begin
                    state <= 2'b10; // Move to '110' detected state
                end else begin
                    state <= 2'b00; // Reset to initial state on '0'
                end
            end
            2'b10: begin // '110' detected
                if(data == 1'b0) begin
                    state <= 2'b11; // Move to '1101' detected state and set start_shifting
                    start_shifting <= 1;
                end else begin
                    state <= 2'b01; // Stay in '11' detected state on '1'
                end
            end
            2'b11: begin // '1101' detected
                // Do nothing, maintain state and start_shifting signal
            end
            default: state <= 2'b00; // Default to initial state
        endcase
    end
end

endmodule