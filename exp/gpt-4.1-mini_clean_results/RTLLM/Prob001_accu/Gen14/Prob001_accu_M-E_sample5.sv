module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_regs [3:0];  // Store up to 4 inputs
    reg [1:0] count;            // Counts number of received inputs (0-3)

    integer i;
    reg [9:0] sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'd0;
            valid_out <= 1'b0;
            data_out <= 10'd0;
            for (i = 0; i < 4; i = i + 1)
                data_regs[i] <= 8'd0;
        end else begin
            valid_out <= 1'b0;
            if (valid_in) begin
                data_regs[count] <= data_in;
                if (count == 2'd3) begin
                    // On receiving 4th input, sum all and output
                    sum = data_regs[0] + data_regs[1] + data_regs[2] + data_in;
                    data_out <= sum;
                    valid_out <= 1'b1;
                    count <= 2'd0; // Reset count for next group
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule