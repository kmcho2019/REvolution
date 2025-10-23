module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_buf [0:3];   // Buffer to store up to 4 inputs
    reg [1:0] count;            // Count how many inputs have been stored

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count     <= 2'd0;
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            for (i=0; i<4; i=i+1) begin
                data_buf[i] <= 8'd0;
            end
        end else begin
            valid_out <= 1'b0; // Default no output pulse

            if (valid_in) begin
                data_buf[count] <= data_in;
                if (count == 2'd3) begin
                    // Sum all four buffered inputs in combinational way
                    data_out <= data_buf[0] + data_buf[1] + data_buf[2] + data_in;
                    valid_out <= 1'b1;
                    count <= 2'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule