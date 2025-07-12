module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // State register: 0 - A, 1 - B
reg [1:0] count; // Count of w = 1 over 3 cycles
reg [1:0] cycle; // Cycle counter within state B

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset state to A
        count <= 0;
        cycle <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to state B
                    cycle <= 1; // Start cycle count
                    count <= w; // Initialize count
                end
            end
            1: begin // State B
                cycle <= cycle + 1; // Increment cycle count
                if (w) begin
                    count <= count + 1; // Increment count if w = 1
                end
                if (cycle == 3) begin // End of 3 cycles
                    z <= (count == 2); // Set z based on count
                    cycle <= 1; // Reset cycle count
                    count <= w; // Reset count
                end
            end
        endcase
    end
end

endmodule