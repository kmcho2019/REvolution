module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg count;  // 1-bit counter (counts mod 4)
reg [7:0] sum0, sum1;  // Partial sums
reg [7:0] carry;       // Carry bits
reg [1:0] valid_count; // Tracks valid inputs

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        count <= 1'b0;
        sum0 <= 8'b0;
        sum1 <= 8'b0;
        carry <= 8'b0;
        valid_count <= 2'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            // Carry-save accumulation
            {carry, sum0} <= sum0 + data_in;
            sum1 <= sum1 + carry;
            
            // 1-bit counter (mod 4)
            count <= ~count;
            
            // Track valid inputs
            if (valid_count == 2'b11) begin
                // On 4th input: output final sum
                data_out <= {2'b0, sum0} + {2'b0, sum1} + {2'b0, carry};
                valid_out <= 1'b1;
                // Reset accumulators
                sum0 <= 8'b0;
                sum1 <= 8'b0;
                carry <= 8'b0;
                valid_count <= 2'b0;
            end
            else begin
                valid_count <= valid_count + 1'b1;
            end
        end
    end
end

endmodule