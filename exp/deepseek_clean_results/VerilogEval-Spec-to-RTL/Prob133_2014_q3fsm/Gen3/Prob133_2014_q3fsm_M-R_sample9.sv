module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State definitions
    reg state;         // 0=A, 1=B
    reg [1:0] counter; // Modulo-3 counter
    reg [2:0] w_shift; // Shift register for w values
    reg evaluate;      // Flag to evaluate in next cycle

    // Count number of 1's in w_shift
    wire [1:0] ones_count = w_shift[0] + w_shift[1] + w_shift[2];
    assign z = evaluate && (ones_count == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            counter <= 0;
            w_shift <= 0;
            evaluate <= 0;
        end else begin
            evaluate <= 0; // Clear evaluation flag by default
            
            case (state)
                0: begin // State A
                    if (s) begin
                        state <= 1;
                        counter <= 0;
                        w_shift <= 0;
                    end
                end
                
                1: begin // State B
                    // Shift in new w value
                    w_shift <= {w_shift[1:0], w};
                    
                    // Update counter (modulo 3)
                    counter <= (counter == 2'd2) ? 2'd0 : counter + 1;
                    
                    // Set evaluation flag at end of window
                    if (counter == 2'd2) begin
                        evaluate <= 1;
                    end
                end
            endcase
        end
    end

endmodule