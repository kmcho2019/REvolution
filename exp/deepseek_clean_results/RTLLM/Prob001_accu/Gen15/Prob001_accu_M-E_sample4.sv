module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [7:0] data_reg [0:3];  // 4-entry shift register
    reg [1:0] count;
    reg [1:0] wr_ptr;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all registers and pointers
            for (integer i = 0; i < 4; i = i + 1)
                data_reg[i] <= 8'b0;
            count <= 2'b0;
            wr_ptr <= 2'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else begin
            valid_out <= 1'b0;
            
            if (valid_in) begin
                // Shift in new data
                data_reg[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
                
                // Update count of valid inputs
                if (count < 3)
                    count <= count + 1;
                else begin
                    // When we have 4 inputs, compute sum
                    data_out <= data_reg[0] + data_reg[1] + 
                                 data_reg[2] + data_reg[3];
                    valid_out <= 1'b1;
                    count <= 2'b0;
                end
            end
        end
    end

endmodule