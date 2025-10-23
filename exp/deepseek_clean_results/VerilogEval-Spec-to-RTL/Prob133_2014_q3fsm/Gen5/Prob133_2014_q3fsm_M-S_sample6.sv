module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;
    
    reg [1:0] cycle;
    reg [2:0] window;

    // Output is high when in B, at end of window, and exactly two 1's
    assign z = (state == B) && (cycle == 2) && ((window[0] + window[1] + window[2]) == 2);

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle <= 0;
            window <= 0;
        end else begin
            case (state)
                A: if (s) begin
                    state <= B;
                    cycle <= 0;
                    window <= {2'b00, w}; // Initialize window with first w
                end
                B: begin
                    if (cycle == 2) begin
                        cycle <= 0;          // Reset counter after 3 cycles
                        window <= {2'b00, w}; // Start new window with first w
                    end else begin
                        cycle <= cycle + 1;   // Increment counter
                        window <= {window[1:0], w}; // Shift in new w
                    end
                end
            endcase
        end
    end

endmodule