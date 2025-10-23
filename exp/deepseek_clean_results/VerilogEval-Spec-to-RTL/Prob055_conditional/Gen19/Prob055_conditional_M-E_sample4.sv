module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

    reg [3:0] active;  // Tracks active candidates (bit0:a, bit1:b, bit2:c, bit3:d)
    wire [3:0] bits = {d[7], c[7], b[7], a[7]};  // Current bits being compared
    
    integer i;
    always @(*) begin
        active = 4'b1111;  // Start with all candidates active
        
        // Bit-serial comparison from MSB to LSB
        for (i = 7; i >= 0; i = i - 1) begin
            if (active == 4'b0001) begin  // Only a remains
                min = a;
                break;
            end
            else if (active == 4'b0010) begin  // Only b remains
                min = b;
                break;
            end
            else if (active == 4'b0100) begin  // Only c remains
                min = c;
                break;
            end
            else if (active == 4'b1000) begin  // Only d remains
                min = d;
                break;
            end
            else begin
                // Find the minimum bit among active candidates
                if ((active[0] && !a[i]) || 
                    (active[1] && !b[i]) || 
                    (active[2] && !c[i]) || 
                    (active[3] && !d[i])) begin
                    // Eliminate candidates with 1 in this bit position
                    active[0] = active[0] && !a[i];
                    active[1] = active[1] && !b[i];
                    active[2] = active[2] && !c[i];
                    active[3] = active[3] && !d[i];
                end
            end
        end
        
        // Final selection if multiple candidates remain
        if (active[0]) min = a;
        else if (active[1]) min = b;
        else if (active[2]) min = c;
        else min = d;
    end

endmodule