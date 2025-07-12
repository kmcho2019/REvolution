module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

// Internal states
enum logic [1:0] {A, B} state, next_state;

// Counter to track w = 1 occurrences
logic [1:0] w_count;

// Shift register to track last three w values
logic [2:0] w_shift;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
        w_count <= 0;
        w_shift <= 0;
        z <= 0;
    end else begin
        case (state)
            A: begin
                if (s) begin
                    state <= B;
                end else begin
                    state <= A;
                end
                w_count <= 0;
                w_shift <= 0;
                z <= 0;
            end
            B: begin
                // Shift in new w value
                w_shift <= {w_shift[1:0], w};
                
                // Increment count if w = 1
                if (w) begin
                    w_count <= w_count + 1;
                end
                
                // If all three w values have been checked
                if (w_shift[2] == 1'b1) begin
                    // Set z based on count
                    if (w_count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    
                    // Reset count and shift for next cycle
                    w_count <= 0;
                    w_shift <= 0;
                end
                
                state <= B;
            end
        endcase
    end
end

endmodule