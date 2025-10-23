module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
typedef enum {A, B} state_t;
state_t state;
reg [2:0] w_history;  // Shift register for last 3 w values
reg [1:0] cycle_count; // Counts 0-2 for 3-cycle window
wire [1:0] count = w_history[0] + w_history[1] + w_history[2];
reg z_next; // Registered version of z for proper timing

always @(posedge clk) begin
    if (reset) begin
        state <= A;
        w_history <= 3'b0;
        cycle_count <= 2'b0;
        z <= 1'b0;
        z_next <= 1'b0;
    end else begin
        // Default assignments
        z <= z_next;
        z_next <= 1'b0;
        
        case (state)
            A: begin
                if (s) begin
                    state <= B;
                    w_history <= 3'b0;
                    cycle_count <= 2'b0;
                end
            end
            
            B: begin
                // Shift in new w value and increment cycle count
                w_history <= {w_history[1:0], w};
                
                if (cycle_count == 2'd2) begin
                    // After 3 cycles, check count and prepare z for next cycle
                    z_next <= (count == 2'd2);
                    cycle_count <= 2'b0; // Reset for next window
                end else begin
                    cycle_count <= cycle_count + 1'b1;
                end
            end
        endcase
    end
end

endmodule