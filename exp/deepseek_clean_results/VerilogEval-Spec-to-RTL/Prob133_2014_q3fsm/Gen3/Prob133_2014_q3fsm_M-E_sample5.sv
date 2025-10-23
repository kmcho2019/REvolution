module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
typedef enum {A, B} state_t;
state_t state, next_state;
reg [2:0] window;  // 3-bit sliding window
reg window_ready;  // Flag indicating window is full
wire [1:0] ones_count = window[0] + window[1] + window[2];

always @(posedge clk) begin
    if (reset) begin
        state <= A;
        window <= 3'b0;
        window_ready <= 1'b0;
        z <= 1'b0;
    end else begin
        state <= next_state;
        
        // Shift in new w value and track window status
        if (state == B) begin
            window <= {window[1:0], w};
            window_ready <= (window_ready == 0) ? &(|window[1:0]) : 1'b1;
        end else begin
            window <= 3'b0;
            window_ready <= 1'b0;
        end
        
        // Output logic (registered)
        z <= (state == B) && window_ready && (ones_count == 2'd2);
    end
end

always_comb begin
    next_state = state;
    case (state)
        A: if (s) next_state = B;
        B: if (~s) next_state = A;  // Optional: return to A if s goes low
    endcase
end

endmodule