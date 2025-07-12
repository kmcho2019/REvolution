module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // 4-stage shift register
    reg [7:0] data_reg [0:3];
    reg [1:0] count;
    wire [9:0] sum;

    // Shift register and counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg[0] <= 8'b0;
            data_reg[1] <= 8'b0;
            data_reg[2] <= 8'b0;
            data_reg[3] <= 8'b0;
            count <= 2'b0;
        end else if (valid_in) begin
            // Shift new data in
            data_reg[3] <= data_reg[2];
            data_reg[2] <= data_reg[1];
            data_reg[1] <= data_reg[0];
            data_reg[0] <= data_in;
            
            // Update counter
            count <= (count == 2'd3) ? 2'd0 : count + 1;
        end
    end

    // Parallel adder tree (combinational)
    assign sum = data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];

    // Output registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            // Update output only when we have 4 valid inputs
            valid_out <= (count == 2'd3) & valid_in;
            if ((count == 2'd3) & valid_in) begin
                data_out <= sum;
            end
        end
    end

endmodule