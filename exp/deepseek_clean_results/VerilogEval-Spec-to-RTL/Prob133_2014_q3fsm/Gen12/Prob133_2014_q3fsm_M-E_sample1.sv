module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Window tracking
    reg [2:0] w_window;
    reg [1:0] ones_count;  // Tracks number of 1s in current window
    
    // State transition and window logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_window <= 3'b0;
            ones_count <= 2'b0;
            z <= 1'b0;
        end else begin
            // Default output
            z <= 1'b0;
            
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        // Initialize window with first w
                        w_window <= {2'b0, w};
                        ones_count <= w ? 2'b1 : 2'b0;
                    end
                end
                
                B: begin
                    // Update window and count
                    w_window <= {w_window[1:0], w};
                    
                    // Update running count:
                    // Subtract outgoing bit (MSB) and add incoming bit (w)
                    ones_count <= ones_count - w_window[2] + w;
                    
                    // Check for window boundary and condition
                    if (ones_count == 2'd2) begin
                        z <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule