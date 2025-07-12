module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State definitions (one-hot)
    reg state_A, state_B;
    
    // Combined counter and shift register
    reg [2:0] counter_w;
    
    // Evaluation flag
    reg evaluate;
    
    // LUT for ones count (4 possible values)
    wire [1:0] ones_count = (counter_w == 3'b000) ? 2'd0 :
                           (counter_w == 3'b001 || counter_w == 3'b010 || counter_w == 3'b100) ? 2'd1 :
                           (counter_w == 3'b011 || counter_w == 3'b101 || counter_w == 3'b110) ? 2'd2 :
                           2'd3;
    
    assign z = evaluate && (ones_count == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            state_A <= 1;
            state_B <= 0;
            counter_w <= 0;
            evaluate <= 0;
        end else begin
            // Default clear evaluate
            evaluate <= 0;
            
            if (state_A) begin
                if (s) begin
                    state_A <= 0;
                    state_B <= 1;
                    counter_w <= 0;
                end
            end else if (state_B) begin
                // Shift in new w value and count
                counter_w <= {counter_w[1:0], w};
                
                // Evaluate at end of 3-cycle window
                if (&counter_w[1:0]) begin  // Equivalent to counter == 2
                    evaluate <= 1;
                end
            end
        end
    end

endmodule