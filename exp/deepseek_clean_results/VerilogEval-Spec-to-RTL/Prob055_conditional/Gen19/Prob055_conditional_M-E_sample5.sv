module TopModule #(parameter WIDTH = 8) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [WIDTH-1:0] c,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] min
);

    reg [3:0] mask;  // Bitmask for active candidates (a=bit0, b=bit1, etc.)
    integer i;

    always @(*) begin
        // Initialize all candidates as active
        mask = 4'b1111;
        min = {WIDTH{1'b1}};  // Initialize to all ones
        
        for (i = WIDTH-1; i >= 0; i = i-1) begin
            // Find minimum bit among active candidates
            reg min_bit;
            min_bit = 1'b1;
            
            if (mask[0] && (a[i] < min_bit)) min_bit = a[i];
            if (mask[1] && (b[i] < min_bit)) min_bit = b[i];
            if (mask[2] && (c[i] < min_bit)) min_bit = c[i];
            if (mask[3] && (d[i] < min_bit)) min_bit = d[i];
            
            // Update mask to keep only candidates with min_bit in current position
            mask[0] = mask[0] && (a[i] == min_bit);
            mask[1] = mask[1] && (b[i] == min_bit);
            mask[2] = mask[2] && (c[i] == min_bit);
            mask[3] = mask[3] && (d[i] == min_bit);
            
            // Set output bit
            min[i] = min_bit;
            
            // Early exit if only one candidate remains
            if ($countones(mask) == 1) begin
                // Copy remaining bits from the winning candidate
                case (1)
                    mask[0]: min[i-1:0] = a[i-1:0];
                    mask[1]: min[i-1:0] = b[i-1:0];
                    mask[2]: min[i-1:0] = c[i-1:0];
                    mask[3]: min[i-1:0] = d[i-1:0];
                endcase
                break;
            end
        end
    end

endmodule