module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Shift register for input data
    reg [7:0] data_shift [0:3];
    reg [1:0] count;
    wire [9:0] sum;

    // Parallel adder tree
    assign sum = {2'b0, data_shift[0]} + 
                 {2'b0, data_shift[1]} + 
                 {2'b0, data_shift[2]} + 
                 {2'b0, data_shift[3]};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            data_shift[0] <= 8'b0;
            data_shift[1] <= 8'b0;
            data_shift[2] <= 8'b0;
            data_shift[3] <= 8'b0;
            count <= 2'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else begin
            // Shift register update
            if (valid_in) begin
                data_shift[0] <= data_in;
                data_shift[1] <= data_shift[0];
                data_shift[2] <= data_shift[1];
                data_shift[3] <= data_shift[2];
                
                // Counter logic
                if (count == 2'b11) begin
                    count <= 2'b0;
                    valid_out <= 1'b1;
                    data_out <= sum;
                end else begin
                    count <= count + 1;
                    valid_out <= 1'b0;
                end
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule