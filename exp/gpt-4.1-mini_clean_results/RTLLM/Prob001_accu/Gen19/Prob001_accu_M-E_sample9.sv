module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] shift_reg [0:3]; // 4-entry shift register to hold 4 inputs
    reg [2:0] count;           // 3 bits count, max 4

    integer i;

    // Sum wires for combinational addition of 4 inputs
    wire [9:0] sum0 = {2'b00, shift_reg[0]}; // extend to 10 bits
    wire [9:0] sum1 = {2'b00, shift_reg[1]};
    wire [9:0] sum2 = {2'b00, shift_reg[2]};
    wire [9:0] sum3 = {2'b00, shift_reg[3]};
    wire [10:0] sum_4; // 11 bits for sum of four 8-bit numbers (max 1020 < 2^10, but safe to have 11 bits)

    assign sum_4 = sum0 + sum1 + sum2 + sum3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count     <= 3'd0;
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            for (i = 0; i < 4; i = i + 1) begin
                shift_reg[i] <= 8'd0;
            end
        end else begin
            valid_out <= 1'b0; // default no valid output

            if (valid_in) begin
                // Shift existing data left
                shift_reg[3] <= shift_reg[2];
                shift_reg[2] <= shift_reg[1];
                shift_reg[1] <= shift_reg[0];
                shift_reg[0] <= data_in;

                if (count == 3'd3) begin
                    // 4th valid input received, output sum of all 4 values
                    data_out <= sum_4[9:0]; // max sum fits in 10 bits
                    valid_out <= 1'b1;
                    count <= 3'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule