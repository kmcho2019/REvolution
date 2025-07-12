module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    reg [7:0] candidates [0:3];
    reg [3:0] active;
    integer i;
    
    always @(*) begin
        // Initialize
        candidates[0] = a;
        candidates[1] = b;
        candidates[2] = c;
        candidates[3] = d;
        active = 4'b1111;
        
        // Bitwise comparison from MSB to LSB
        for (i = 7; i >= 0; i = i - 1) begin
            // Find the minimum bit value among active candidates
            reg min_bit = 1'b1;
            integer j;
            for (j = 0; j < 4; j = j + 1) begin
                if (active[j] && (candidates[j][i] < min_bit)) begin
                    min_bit = candidates[j][i];
                end
            end
            
            // Deactivate candidates with higher bits
            for (j = 0; j < 4; j = j + 1) begin
                if (active[j] && (candidates[j][i] > min_bit)) begin
                    active[j] = 1'b0;
                end
            end
            
            // Exit early if only one candidate remains
            if ($countones(active) == 1) begin
                i = -1; // break the loop
            end
        end
        
        // Output the remaining active candidate
        case (1'b1)
            active[0]: min = a;
            active[1]: min = b;
            active[2]: min = c;
            active[3]: min = d;
            default: min = a; // should never happen
        endcase
    end

endmodule