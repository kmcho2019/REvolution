module TopModule(clk, reset, s, w, z);
    input clk;
    input reset;
    input s;
    input w;
    output z;

    reg [1:0] state; // States: 0 - A, 1 - B, 2 - Counting (subset of B)
    reg [1:0] count; // Counter for w = 1 in three clock cycles
    reg [1:0] cycle; // Cycle counter within state B

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0; // Reset to state A
            count <= 0;
            cycle <= 0;
            z <= 0;
        end else begin
            case (state)
                0: begin // State A
                    if (s) begin
                        state <= 1; // Transition to state B
                        count <= 0;
                        cycle <= 0;
                    end
                end
                1: begin // State B (counting phase)
                    if (cycle == 0) begin // Start of counting phase
                        count <= 0;
                    end
                    if (w) begin
                        count <= count + 1;
                    end
                    cycle <= cycle + 1;
                    if (cycle == 3) begin // End of counting phase
                        z <= (count == 2) ? 1 : 0; // Set z based on count
                        cycle <= 0; // Reset cycle counter
                    end
                end
            endcase
        end
    end
endmodule