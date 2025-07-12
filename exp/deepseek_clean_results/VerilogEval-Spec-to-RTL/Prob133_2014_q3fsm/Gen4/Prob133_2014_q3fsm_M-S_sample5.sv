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

    // Output is high when in B, at end of window (cycle=2), and exactly two 1's
    assign z = (state == B) && (cycle == 2) && 
               ((window == 3'b011) || (window == 3'b101) || (window == 3'b110));

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
                    window <= {2'b00, w}; // Start new window
                end
                B: begin
                    window <= {window[1:0], w}; // Shift in new w
                    cycle <= (cycle == 2) ? 0 : cycle + 1; // Count 0-1-2
                end
            endcase
        end
    end

endmodule