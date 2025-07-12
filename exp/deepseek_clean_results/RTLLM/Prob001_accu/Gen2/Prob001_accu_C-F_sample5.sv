module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] count;  // 0-3 counter (2 bits sufficient)
reg [9:0] accum;   // Accumulator (10 bits for max sum 1020)
wire [9:0] next_sum = accum + data_in;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 2'b00;
        accum <= 10'b0;
        data_out <= 10'b0;
        valid_out <= 1'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            if (count == 2'b11) begin
                // On 4th valid input
                data_out <= next_sum;  // Use combinational sum
                valid_out <= 1'b1;    // Pulse valid for one cycle
                accum <= 10'b0;        // Reset accumulator
                count <= 2'b00;         // Reset counter
            end
            else begin
                // Accumulate normally
                accum <= next_sum;
                count <= count + 1'b1;
            end
        end
    end
end

endmodule