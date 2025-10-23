module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [7:0] data_reg [0:3];  // 4-entry shift register
    reg [1:0] count;           // 0-3 counter
    wire [9:0] sum;            // Combinational sum

    // Parallel adder
    assign sum = data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear shift register and counter
            for (integer i = 0; i < 4; i = i + 1)
                data_reg[i] <= 8'b0;
            count <= 2'b00;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else begin
            valid_out <= 1'b0;  // Default

            if (valid_in) begin
                // Shift in new data
                data_reg[3] <= data_reg[2];
                data_reg[2] <= data_reg[1];
                data_reg[1] <= data_reg[0];
                data_reg[0] <= data_in;

                // Update counter
                if (count == 2'b11) begin
                    count <= 2'b00;
                    // Output result
                    data_out <= sum;
                    valid_out <= 1'b1;
                end else begin
                    count <= count + 1;
                end
            end
        end
    end

endmodule