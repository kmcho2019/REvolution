module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
parameter A = 0, B = 1;

// Current state
reg current_state;

// Counters
reg [1:0] count;
reg [1:0] w_count;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Reset state
        current_state <= A;
        count <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (current_state)
            A: begin
                if (s) begin
                    // Transition to state B
                    current_state <= B;
                    count <= 1;
                    w_count <= w;
                end else begin
                    // Remain in state A
                    current_state <= A;
                    count <= 0;
                    w_count <= 0;
                end
                z <= 0;
            end
            B: begin
                if (count < 3) begin
                    // Increment count and update w_count
                    count <= count + 1;
                    if (w) begin
                        w_count <= w_count + 1;
                    end
                    current_state <= B;
                    z <= 0;
                end else begin
                    // Check w_count and reset counters
                    if (w_count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    current_state <= B;
                    count <= 1;
                    w_count <= w;
                end
            end
        endcase
    end
end

endmodule