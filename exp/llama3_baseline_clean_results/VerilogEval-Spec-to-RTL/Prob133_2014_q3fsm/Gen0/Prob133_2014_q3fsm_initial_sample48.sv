module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State register, 2 bits to represent states A and B
reg [2:0] counter; // Counter to track the number of clock cycles in state B
reg [1:0] w_count; // Counter to track the occurrences of w=1 in the last three cycles

always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        state <= 0; // Reset state A
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin // Transition to state B when s=1
                    state <= 1;
                    counter <= 1; // Start counting clock cycles in state B
                    w_count <= w; // Initialize w_count with the current value of w
                end
            end
            1: begin // State B
                counter <= counter + 1; // Increment clock cycle counter
                w_count <= {w_count[0], w}; // Shift w_count and add the current w value
                if (counter == 3) begin // After three clock cycles
                    z <= (w_count == 2'b01 || w_count == 2'b10 || w_count == 2'b11)? 1 : 0; // Set z based on w_count
                    counter <= 1; // Reset counter for the next three cycles
                    w_count <= w; // Reset w_count with the current w
                end
            end
        endcase
    end
end

endmodule