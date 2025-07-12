module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_reg [3:0]; // 4-entry shift register to hold inputs
    reg [1:0] count;

    wire [9:0] sum; // sum of 4 x 8-bit inputs (max 4*255=1020 fits in 10 bits)

    integer i;

    // combinational sum of the four stored data elements
    assign sum = data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers and outputs
            for (i=0; i<4; i=i+1) begin
                data_reg[i] <= 8'd0;
            end
            count     <= 2'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default low

            if (valid_in) begin
                // Shift in new data_in
                data_reg[0] <= data_in;
                data_reg[1] <= data_reg[0];
                data_reg[2] <= data_reg[1];
                data_reg[3] <= data_reg[2];

                if (count == 2'd3) begin
                    // On 4th valid input: output sum of all 4 stored inputs
                    data_out  <= sum;
                    valid_out <= 1'b1;
                    count     <= 2'd0;
                    // Clear data_reg after output to avoid stale data accumulation
                    for (i=0; i<4; i=i+1) begin
                        data_reg[i] <= 8'd0;
                    end
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule