module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;        // 2-bit counter (0-3)
    reg [9:0] accumulator;  // 10-bit accumulator
    reg [9:0] sum_pipe;     // Pipeline register for adder

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            accumulator <= 10'b0;
            sum_pipe <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Default outputs
            valid_out <= 1'b0;
            
            if (valid_in) begin
                // Pipeline the adder to break critical path
                sum_pipe <= accumulator + data_in;
                
                if (&count) begin  // count == 2'b11 using bitwise AND
                    // On 4th input: output sum and reset
                    data_out <= sum_pipe;
                    valid_out <= 1'b1;
                    count <= 2'b00;
                    accumulator <= 10'b0;
                end
                else begin
                    // Accumulate input and increment count
                    accumulator <= sum_pipe;
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule