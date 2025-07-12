module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] current_state; // 0: State A, 1: State B
reg [1:0] counter; // Counter to keep track of the number of clock cycles in state B
reg w_count; // Number of times w is 1 in the last three clock cycles

always @(posedge clk) begin
    if (reset) begin
        current_state <= 0; // Reset to state A
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (current_state)
            0: begin // State A
                if (s) begin
                    current_state <= 1; // Transition to state B
                    counter <= 1; // Reset counter
                    w_count <= w; // Initialize w_count
                end
            end
            1: begin // State B
                if (counter < 3) begin
                    counter <= counter + 1;
                    w_count <= w_count + w;
                end else begin
                    counter <= 1; // Reset counter
                    w_count <= w; // Initialize w_count
                    if (w_count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                end
            end
        endcase
    end
end

endmodule