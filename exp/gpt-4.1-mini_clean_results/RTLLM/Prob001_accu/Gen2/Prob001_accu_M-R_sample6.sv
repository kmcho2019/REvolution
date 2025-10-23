module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [9:0] accumulator;
    reg [1:0] count;

    // Next values for accumulator and count
    wire [9:0] acc_next = accumulator + data_in;
    wire [1:0] count_next = count + 1'b1;

    // valid_out is high only when the fourth valid_in data is received (count==3 and valid_in=1)
    wire output_enable = (count == 2'd3) && valid_in;

    // Counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'd0;
        end else if (output_enable) begin
            count <= 2'd0;  // Reset after reaching 4 data_in
        end else if (valid_in) begin
            count <= count_next;
        end
    end

    // Accumulator update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
        end else if (output_enable) begin
            accumulator <= 10'd0;  // Reset accumulator after output
        end else if (valid_in) begin
            accumulator <= acc_next;
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= output_enable;
            if (output_enable) begin
                data_out <= acc_next;  // Output sum of 4 data_in values
            end
        end
    end

endmodule