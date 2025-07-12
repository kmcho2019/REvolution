module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // States: 0 - A, 1 - B
reg [1:0] counter; // Counter for w=1 instances
reg [1:0] cycle; // Counter for three cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        counter <= 0;
        cycle <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                    counter <= 0;
                    cycle <= 1;
                end
            end
            1: begin // State B
                if (cycle == 3) begin // End of three cycles
                    if (counter == 2) begin // Exactly two w=1 instances
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    state <= 1; // Stay in state B
                    counter <= 0;
                    cycle <= 1;
                end else begin
                    if (w) begin
                        counter <= counter + 1; // Increment counter if w=1
                    end
                    cycle <= cycle + 1; // Increment cycle counter
                end
            end
        endcase
    end
end

endmodule