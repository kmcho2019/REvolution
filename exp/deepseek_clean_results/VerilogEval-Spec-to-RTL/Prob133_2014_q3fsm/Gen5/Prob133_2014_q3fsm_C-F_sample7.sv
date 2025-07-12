module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    reg [1:0] cycle_count;  // Modulo-3 counter (0-2)
    reg [2:0] w_window;     // Shift register for last 3 w values
    reg evaluate;           // Evaluation trigger
    
    // Combinational output logic
    wire [1:0] ones_count = w_window[0] + w_window[1] + w_window[2];
    assign z = evaluate && (ones_count == 2'd2);
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_window <= 3'b000;
            evaluate <= 1'b0;
        end else begin
            // Default clear evaluation flag
            evaluate <= 1'b0;
            
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        cycle_count <= 2'b00;
                        w_window <= 3'b000;
                    end
                end
                
                B: begin
                    // Update window with new w value
                    w_window <= {w_window[1:0], w};
                    
                    // Update modulo-3 counter
                    cycle_count <= (cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1);
                    
                    // Set evaluation flag at end of each 3-cycle window
                    if (cycle_count == 2'd2) begin
                        evaluate <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule