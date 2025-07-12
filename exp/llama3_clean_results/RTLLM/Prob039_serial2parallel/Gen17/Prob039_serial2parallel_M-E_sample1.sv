module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] state; // Finite state machine state
reg [7:0] shift_reg; // Shift register for storing incoming serial data

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state, shift register, and output signals
        state <= 3'b000;
        shift_reg <= 8'b00000000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // Idle state
                if (din_valid) begin
                    // Transition to data reception state and reset shift register
                    state <= 3'b001;
                    shift_reg <= {din_serial, 7'b0000000};
                end else begin
                    // Remain in idle state
                    state <= 3'b000;
                end
            end
            3'b001: begin // Data reception state
                if (din_valid) begin
                    // Shift in new data bit
                    shift_reg <= {din_serial, shift_reg[7:1]};
                    // If eight bits have been received, transition back to idle state
                    if (&shift_reg[7:5]) begin // Using & operator to check if all bits are 1
                        state <= 3'b000;
                        dout_parallel <= shift_reg;
                        dout_valid <= 1'b1;
                    end else begin
                        // Remain in data reception state
                        state <= 3'b001;
                    end
                end else begin
                    // Transition back to idle state if no valid data
                    state <= 3'b000;
                end
            end
            default: begin
                // Default state, should not occur
                state <= 3'b000;
            end
        endcase
    end
end

endmodule