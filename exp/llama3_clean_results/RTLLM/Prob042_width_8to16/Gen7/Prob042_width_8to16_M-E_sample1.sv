module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0]  data_out
);

reg [1:0] state; // Finite State Machine state register
reg [7:0] stored_data; // Register to store the first 8-bit data input

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state          <= 2'd0; // Reset state to idle
        stored_data    <= 8'd0; // Clear stored data
        valid_out      <= 1'b0; // Reset valid_out
        data_out       <= 16'd0; // Reset data_out
    end
    else begin
        case (state)
            2'd0: begin // Idle state
                if (valid_in) begin
                    stored_data <= data_in; // Store the first valid data
                    state      <= 2'd1; // Transition to waiting state
                end
                valid_out <= 1'b0; // No output yet
            end
            2'd1: begin // Waiting for second data
                if (valid_in) begin
                    data_out  <= {stored_data, data_in}; // Concatenate data
                    valid_out <= 1'b1; // Output is valid
                    state    <= 2'd0; // Return to idle state
                end
                else begin
                    valid_out <= 1'b0; // Output not valid if no second data
                end
            end
            default: begin
                state      <= 2'd0; // Default to idle state
                valid_out <= 1'b0; // Ensure no invalid output
            end
        endcase
    end
end

endmodule