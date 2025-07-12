module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // States: 0 - searching for byte 1, 1 - received byte 1, 2 - received byte 2
reg [7:0] byte_count; // Not needed, we can use state to track byte count

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to searching for byte 1 state
        done <= 0; // Reset done signal
    end else begin
        case (state)
            0: begin // Searching for byte 1
                if (in[3] == 1'b1) begin // Found byte 1
                    state <= 1; // Move to received byte 1 state
                end
            end
            1: begin // Received byte 1
                state <= 2; // Move to received byte 2 state
            end
            2: begin // Received byte 2
                state <= 0; // Move back to searching for byte 1 state after signaling done
                done <= 1'b1; // Signal done
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == 2) begin
        done <= 1'b1; // Ensure done is set for one clock cycle
    end else begin
        done <= 1'b0; // Reset done signal
    end
end

endmodule