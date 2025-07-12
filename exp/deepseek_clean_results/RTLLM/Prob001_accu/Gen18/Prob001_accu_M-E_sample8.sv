module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Shift register for last 4 values
    reg [7:0] data_reg [0:3];
    reg [1:0] count;
    wire full = (count == 2'd3);

    // Parallel adder wires
    wire [9:0] sum = {2'b0, data_reg[0]} + 
                    {2'b0, data_reg[1]} + 
                    {2'b0, data_reg[2]} + 
                    {2'b0, data_reg[3]};

    // Shift register and counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg[0] <= 8'b0;
            data_reg[1] <= 8'b0;
            data_reg[2] <= 8'b0;
            data_reg[3] <= 8'b0;
            count <= 2'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else if (valid_in) begin
            // Shift in new data
            data_reg[3] <= data_reg[2];
            data_reg[2] <= data_reg[1];
            data_reg[1] <= data_reg[0];
            data_reg[0] <= data_in;

            // Update counter
            if (full) begin
                count <= 2'b0;
                valid_out <= 1'b1;
                data_out <= sum;
            end else begin
                count <= count + 1'b1;
                valid_out <= 1'b0;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end

endmodule