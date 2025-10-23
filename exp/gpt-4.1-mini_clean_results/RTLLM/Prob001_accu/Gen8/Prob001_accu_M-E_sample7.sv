module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_regs [0:3];    // Storage for 4 inputs
    reg [1:0] count;              // Counts valid inputs 0 to 3

    wire [9:0] sum_0_1;
    wire [9:0] sum_2_3;
    wire [9:0] total_sum;

    // Combinational additions in a tree structure
    assign sum_0_1 = data_regs[0] + data_regs[1];
    assign sum_2_3 = data_regs[2] + data_regs[3];
    assign total_sum = sum_0_1 + sum_2_3;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            count     <= 2'd0;
            for (i = 0; i < 4; i = i + 1) begin
                data_regs[i] <= 8'd0;
            end
        end else begin
            valid_out <= 1'b0; // Default low

            if (valid_in) begin
                data_regs[count] <= data_in;
                if (count == 2'd3) begin
                    data_out  <= total_sum;
                    valid_out <= 1'b1;
                    count     <= 2'd0;
                    // Clear registers for next batch
                    for (i = 0; i < 4; i = i + 1) begin
                        data_regs[i] <= 8'd0;
                    end
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule