module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

    always @* begin
        reg [3:0] candidates = 4'b1111; // All inputs are initially candidates
        reg [7:0] current_min = 8'hFF;
        
        for (integer i = 7; i >= 0; i = i - 1) begin
            // Check each candidate's current bit
            reg a_bit = candidates[0] ? a[i] : 1;
            reg b_bit = candidates[1] ? b[i] : 1;
            reg c_bit = candidates[2] ? c[i] : 1;
            reg d_bit = candidates[3] ? d[i] : 1;
            
            // Find the minimum bit among active candidates
            reg min_bit = a_bit & b_bit & c_bit & d_bit;
            
            // Update candidate list
            if (candidates[0] && (a[i] != min_bit)) candidates[0] = 0;
            if (candidates[1] && (b[i] != min_bit)) candidates[1] = 0;
            if (candidates[2] && (c[i] != min_bit)) candidates[2] = 0;
            if (candidates[3] && (d[i] != min_bit)) candidates[3] = 0;
            
            // If only one candidate remains, we're done
            if ($countones(candidates) == 1) begin
                case (1'b1)
                    candidates[0]: current_min = a;
                    candidates[1]: current_min = b;
                    candidates[2]: current_min = c;
                    candidates[3]: current_min = d;
                endcase
                break;
            end
        end
        
        // If multiple candidates remain after all bits, pick the first one
        if ($countones(candidates) > 1) begin
            case (1'b1)
                candidates[0]: current_min = a;
                candidates[1]: current_min = b;
                candidates[2]: current_min = c;
                candidates[3]: current_min = d;
            endcase
        end
        
        min = current_min;
    end

endmodule