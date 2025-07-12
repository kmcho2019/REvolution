module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [31:0] data_shift;
    reg [2:0]  count; // count up to 4

    wire [9:0] sum; 
    wire [7:0] data0, data1, data2, data3;

    assign data3 = data_shift[7:0];
    assign data2 = data_shift[15:8];
    assign data1 = data_shift[23:16];
    assign data0 = data_shift[31:24];

    // Sum the four 8-bit values into a 10-bit result
    assign sum = data0 + data1 + data2 + data3;

    always @(posedge clk) begin
        if (!rst_n) begin
            data_shift <= 32'd0;
            count      <= 3'd0;
            data_out   <= 10'd0;
            valid_out  <= 1'b0;
        end else begin
            valid_out <= 1'b0; // Default no output

            if (valid_in) begin
                // Shift in new 8-bit input at MSB side
                data_shift <= {data_shift[23:0], data_in};
                if (count == 3'd3) begin
                    // On 4th input, output sum and reset counter and shift reg
                    data_out  <= sum;
                    valid_out <= 1'b1;
                    count     <= 3'd0;
                    data_shift<= 32'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule