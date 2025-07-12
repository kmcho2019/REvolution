module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] shift_reg [3:0];  // to store 4 inputs
    reg [2:0] count;            // count from 0 to 4

    integer i;
    reg [9:0] sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            data_out <= 10'd0;
            count <= 3'd0;
            for (i = 0; i < 4; i = i + 1) begin
                shift_reg[i] <= 8'd0;
            end
        end else begin
            valid_out <= 1'b0;
            if (valid_in) begin
                // Shift left by one and insert new data at position 0
                shift_reg[3] <= shift_reg[2];
                shift_reg[2] <= shift_reg[1];
                shift_reg[1] <= shift_reg[0];
                shift_reg[0] <= data_in;

                if (count == 3'd3) begin
                    // On the 4th valid input, sum all elements
                    sum = 10'd0;
                    for (i = 0; i < 4; i = i +1) begin
                        sum = sum + shift_reg[i];
                    end
                    sum = sum + data_in; // Add the newest input data_in as well (shift_reg[0] hasn't stored data_in from this cycle yet)
                    data_out <= sum;
                    valid_out <= 1'b1;
                    count <= 3'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule