module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;
    
    reg state;
    reg [1:0] cycle_count;
    reg [1:0] ones_in_window;
    reg w1, w2, w3;  // Parallel window storage
    
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            ones_in_window <= 2'b00;
            w1 <= 1'b0;
            w2 <= 1'b0;
            w3 <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        // Initialize window collection
                        w1 <= w;
                        ones_in_window <= w ? 2'b01 : 2'b00;
                        cycle_count <= 2'b01;
                    end
                end
                
                B: begin
                    // Update window storage and count
                    case (cycle_count)
                        2'b00: begin
                            w1 <= w;
                            ones_in_window <= w ? 2'b01 : 2'b00;
                            cycle_count <= 2'b01;
                        end
                        2'b01: begin
                            w2 <= w;
                            ones_in_window <= ones_in_window + (w ? 1'b1 : 1'b0);
                            cycle_count <= 2'b10;
                        end
                        2'b10: begin
                            w3 <= w;
                            ones_in_window <= ones_in_window + (w ? 1'b1 : 1'b0);
                            cycle_count <= 2'b00;
                        end
                    endcase
                end
            endcase
        end
    end
    
    // Output is high when we complete a window with exactly two 1's
    assign z = (state == B) && (cycle_count == 2'b00) && (ones_in_window == 2'b10);

endmodule