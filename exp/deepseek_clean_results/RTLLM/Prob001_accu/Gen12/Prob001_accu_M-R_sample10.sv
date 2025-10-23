module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;        // Counter for 0-3 (4 inputs)
    reg [9:0] accumulator;  // Accumulator for sum
    
    // Combinational signals
    wire count_full = &count;  // Terminal count (count == 2'b11)
    wire [9:0] next_accum = accumulator + data_in;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 2'b00;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Default outputs
            valid_out <= 1'b0;
            
            // Counter and accumulator update
            if (valid_in) begin
                if (count_full) begin
                    count <= 2'b00;
                    accumulator <= 10'b0;
                end
                else begin
                    count <= count + 1'b1;
                    accumulator <= next_accum;
                end
            end
            
            // Output generation
            if (valid_in && count_full) begin
                data_out <= next_accum;
                valid_out <= 1'b1;
            end
        end
    end

endmodule