module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;        // Binary counter (0-3)
    reg [9:0] accum;        // Running sum
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset
            count <= 2'b00;
            accum <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Default outputs
            valid_out <= 1'b0;
            
            if (valid_in) begin
                // Update accumulator
                accum <= accum + data_in;
                
                if (count == 2'b11) begin
                    // On 4th input, output sum and reset
                    data_out <= accum + data_in;
                    valid_out <= 1'b1;
                    accum <= 10'b0;
                    count <= 2'b00;
                end
                else begin
                    // Increment counter
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule