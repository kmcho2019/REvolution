module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    // 4 registers to hold incoming data
    reg [7:0] shift_reg [3:0];
    reg [2:0] count;  // Counts valid inputs: 0 to 4

    // Wires for addition intermediate sums
    wire [8:0] sum01, sum23;
    wire [9:0] total_sum;

    // Combinational addition of 4 inputs
    assign sum01 = shift_reg[0] + shift_reg[1];   // 8+8 bits -> 9 bits
    assign sum23 = shift_reg[2] + shift_reg[3];   // 8+8 bits -> 9 bits
    assign total_sum = sum01 + sum23;              // 9+9 bits -> 10 bits

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg[0] <= 8'd0;
            shift_reg[1] <= 8'd0;
            shift_reg[2] <= 8'd0;
            shift_reg[3] <= 8'd0;
            count        <= 3'd0;
            data_out     <= 10'd0;
            valid_out    <= 1'b0;
        end else begin
            valid_out <= 1'b0;

            if (valid_in) begin
                // Shift in new data
                shift_reg[0] <= data_in;
                shift_reg[1] <= shift_reg[0];
                shift_reg[2] <= shift_reg[1];
                shift_reg[3] <= shift_reg[2];

                if (count == 3'd3) begin
                    // 4th valid input received -> output sum of all 4
                    data_out  <= total_sum;
                    valid_out <= 1'b1;
                    count     <= 3'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule