module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] shift_reg [3:0];  // 4-element shift register to store inputs
    reg [1:0] count;

    integer i;
    reg [9:0] sum;

    // Combinational addition of 4 stored inputs
    always @* begin
        sum = shift_reg[0] + shift_reg[1] + shift_reg[2] + shift_reg[3];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1)
                shift_reg[i] <= 8'd0;
            count <= 2'd0;
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0; // Default low

            if (valid_in) begin
                // Shift left data to insert new input at shift_reg[0]
                shift_reg[3] <= shift_reg[2];
                shift_reg[2] <= shift_reg[1];
                shift_reg[1] <= shift_reg[0];
                shift_reg[0] <= data_in;

                if (count == 2'd3) begin
                    // On the 4th data input
                    data_out <= sum;
                    valid_out <= 1'b1;
                    count <= 2'd0;

                    // Clear registers (optional, safe practice)
                    for (i = 0; i < 4; i = i + 1)
                        shift_reg[i] <= 8'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule