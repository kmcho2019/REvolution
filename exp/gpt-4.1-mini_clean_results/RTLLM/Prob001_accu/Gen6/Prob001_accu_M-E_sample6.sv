module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_samples [0:3];
    reg [1:0] idx;

    wire [9:0] sum;

    // Combinational sum of four stored samples
    assign sum = data_samples[0] + data_samples[1] + data_samples[2] + data_samples[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            idx       <= 2'd0;
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            data_samples[0] <= 8'd0;
            data_samples[1] <= 8'd0;
            data_samples[2] <= 8'd0;
            data_samples[3] <= 8'd0;
        end else begin
            valid_out <= 1'b0;

            if (valid_in) begin
                data_samples[idx] <= data_in;

                if (idx == 2'd3) begin
                    data_out  <= sum;
                    valid_out <= 1'b1;
                    idx       <= 2'd0;
                end else begin
                    idx <= idx + 1'b1;
                end
            end
        end
    end

endmodule