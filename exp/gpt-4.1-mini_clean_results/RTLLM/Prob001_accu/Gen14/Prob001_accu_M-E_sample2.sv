module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] buffer [3:0];   // Buffer to hold 4 inputs
    reg [1:0] count;          // Counts number of valid inputs stored (0 to 3)
    
    wire [9:0] sum_stage1_0;
    wire [9:0] sum_stage1_1;
    wire [9:0] sum_stage2;

    // Extend to 10 bits for addition to avoid overflow: 8 bits plus 2 bits for max sum of 4*255=1020 (<1024)
    // Sum pairs in stage 1
    assign sum_stage1_0 = buffer[0] + buffer[1];
    assign sum_stage1_1 = buffer[2] + buffer[3];

    // Sum stage 2
    assign sum_stage2 = sum_stage1_0 + sum_stage1_1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count     <= 2'd0;
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            buffer[0] <= 8'd0;
            buffer[1] <= 8'd0;
            buffer[2] <= 8'd0;
            buffer[3] <= 8'd0;
        end else begin
            valid_out <= 1'b0; // default clear

            if (valid_in) begin
                buffer[count] <= data_in;

                if (count == 2'd3) begin
                    // When 4th data received, output the sum of buffer plus current data_in
                    // But data_in is just stored, and buffer now full,
                    // So sum_stage2 represents sum of the 4 buffered data
                    data_out  <= sum_stage2;
                    valid_out <= 1'b1;
                    count     <= 2'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule