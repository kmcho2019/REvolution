module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
typedef enum {A, B} state_t;
reg state;
reg [2:0] w_history;  // Shift register for last 3 w values
wire [1:0] count = w_history[0] + w_history[1] + w_history[2];

always @(posedge clk) begin
    if (reset) begin
        state <= A;
        w_history <= 3'b0;
        z <= 1'b0;
    end else begin
        case (state)
            A: begin
                z <= 1'b0;
                if (s) begin
                    state <= B;
                    w_history <= 3'b0;
                end
            end
            
            B: begin
                // Shift in new w value
                w_history <= {w_history[1:0], w};
                
                // Check if we have 3 samples (always true after first 3 cycles)
                z <= (count == 2'b10);  // Exactly two 1's
            end
        endcase
    end
end

endmodule