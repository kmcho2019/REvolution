module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // 2-bit counter for states
reg [23:0] out_bytes_reg; // 24-bit register for out_bytes
reg done_reg; // 1-bit signal for done
reg [23:0] queue; // 24-bit queue to store incoming bytes
reg [1:0] queue_ptr; // 2-bit pointer for queue

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // Reset state to IDLE
        out_bytes_reg <= 24'b0; // Reset out_bytes to 0
        done_reg <= 1'b0; // Reset done to 0
        queue <= 24'b0; // Reset queue to 0
        queue_ptr <= 2'b00; // Reset queue pointer to 0
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    queue[23:16] <= in; // Store first byte in queue
                    queue_ptr <= 2'b01; // Increment queue pointer
                    state <= 2'b01; // Transition to FILLING state
                end
            end
            2'b01: begin // FILLING state
                queue[15:8] <= in; // Store second byte in queue
                queue_ptr <= 2'b10; // Increment queue pointer
                if (queue_ptr == 2'b10) begin
                    queue[7:0] <= in; // Store third byte in queue
                    state <= 2'b10; // Transition to DONE state
                    done_reg <= 1'b1; // Assert done signal
                end
            end
            2'b10: begin // DONE state
                out_bytes_reg <= queue; // Output stored bytes
                state <= 2'b00; // Transition back to IDLE state
                done_reg <= 1'b0; // Deassert done signal
                queue <= 24'b0; // Reset queue to 0
                queue_ptr <= 2'b00; // Reset queue pointer to 0
            end
            default: begin
                state <= 2'b00; // Default to IDLE state
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule