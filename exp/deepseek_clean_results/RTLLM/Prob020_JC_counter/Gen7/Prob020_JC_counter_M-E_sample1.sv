module JC_counter (
    input clk,
    input rst_n,
    output [63:0] Q
);

// Array of 8-bit Johnson counters
reg [7:0] counter [7:0];

// Generate block for all 8 counters
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : COUNTER_GEN
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                counter[i] <= 8'b0;
            end
            else begin
                if (i == 0) begin
                    // First counter uses its own LSB for MSB
                    counter[i] <= {~counter[i][0], counter[i][7:1]};
                end
                else begin
                    // Other counters use previous counter's LSB for MSB
                    counter[i] <= {~counter[i-1][0], counter[i][7:1]};
                end
            end
        end
    end
endgenerate

// Concatenate all counter outputs
assign Q = {counter[7], counter[6], counter[5], counter[4], 
            counter[3], counter[2], counter[1], counter[0]};

endmodule