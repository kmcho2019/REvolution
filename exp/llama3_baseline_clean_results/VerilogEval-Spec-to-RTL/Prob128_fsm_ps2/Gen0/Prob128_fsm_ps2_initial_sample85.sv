module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 2-bit state register
reg [7:0] byte1, byte2, byte3; // registers to store the bytes of a message
reg done_reg; // register to store the done signal

// Define the states
parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter BYTE3 = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        // Reset the state and registers
        state <= IDLE;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3]) begin
                    // Found a byte with in[3]=1, transition to BYTE1 state
                    state <= BYTE1;
                    byte1 <= in;
                end
            end
            BYTE1: begin
                // Transition to BYTE2 state
                state <= BYTE2;
                byte2 <= in;
            end
            BYTE2: begin
                // Transition to BYTE3 state
                state <= BYTE3;
                byte3 <= in;
            end
            BYTE3: begin
                // Signal done and transition back to IDLE state
                done_reg <= 1'b1;
                state <= IDLE;
            end
        endcase
    end
end

// Output the done signal
assign done = done_reg;

// Reset the done signal in the next cycle
always @(posedge clk) begin
    if (~reset) begin
        done_reg <= 1'b0;
    end
end

endmodule