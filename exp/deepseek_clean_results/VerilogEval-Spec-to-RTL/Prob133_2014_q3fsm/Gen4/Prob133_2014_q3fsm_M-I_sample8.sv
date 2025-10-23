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
    reg [2:0] w_counter;
    
    // Evaluation flag
    reg evaluate;
    
    // LUT for ones_count (pre-calculated for all 8 patterns)
    wire [1:0] ones_count = 
        (w_counter == 3'b000) ? 2'd0 :
        (w_counter == 3'b001) ? 2'd1 :
        (w_counter == 3'b010) ? 2'd1 :
        (w_counter == 3'b011) ? 2'd2 :
        (w_counter == 3'b100) ? 2'd1 :
        (w_counter == 3'b101) ? 2'd2 :
        (w_counter == 3'b110) ? 2'd2 :
        2'd3; // 3'b111
        
    assign z = evaluate && (ones_count == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
            w_counter <= 3'b0;
            evaluate <= 1'b0;
        end else begin
            // Default clear evaluate
            evaluate <= 1'b0;
            
            if (state_A) begin
                if (s) begin
                    state_A <= 1'b0;
                    state_B <= 1'b1;
                    w_counter <= {2'b0, w}; // Initialize counter
                end
            end else if (state_B) begin
                // Shift in new w value and count
                w_counter <= {w_counter[1:0], w};
                
                // Evaluate every 3rd cycle
                if (&w_counter[1:0]) begin // Equivalent to counter == 2
                    evaluate <= 1'b1;
                end
            end
        end
    end

endmodule