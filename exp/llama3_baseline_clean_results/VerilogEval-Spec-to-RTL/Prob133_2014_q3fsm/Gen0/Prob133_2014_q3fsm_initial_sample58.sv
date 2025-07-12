module TopModule(clk, reset, s, w, z);
    input clk, reset, s, w;
    output z;
    reg z;
    reg [1:0] state; // A = 2'b00, B = 2'b01, B1 = 2'b10, B2 = 2'b11
    reg [1:0] counter; // To count cycles in B state
    reg w_count; // Count number of w = 1 in three cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00; // Reset state
            counter <= 2'b00;
            w_count <= 1'b0;
            z <= 1'b0;
        end else begin
            case (state)
                2'b00: begin // State A
                    if (s) begin
                        state <= 2'b01; // Move to state B
                        counter <= 2'b01; // Start counter for B
                        w_count <= w; // Start counting w
                    end
                end
                2'b01: begin // State B
                    if (counter == 2'b11) begin // End of 3 cycles
                        if (w_count == 2'b10) begin // Exactly two w = 1
                            z <= 1'b1; // Set z = 1
                        end else begin
                            z <= 1'b0; // Otherwise z = 0
                        end
                        state <= 2'b01; // Stay in B
                        counter <= 2'b01; // Reset counter
                        w_count <= w; // Reset w_count
                    end else begin
                        if (w) begin
                            w_count <= w_count + 1'b1; // Increment w_count if w = 1
                        end
                        counter <= counter + 1'b1; // Increment counter
                    end
                end
            endcase
        end
    end
endmodule