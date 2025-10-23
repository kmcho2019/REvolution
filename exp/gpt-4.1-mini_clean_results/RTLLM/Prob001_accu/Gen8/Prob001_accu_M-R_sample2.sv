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
    reg       output_pending;

    // Accumulate inputs when valid_in is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            output_pending <= 1'b0;
        end else begin
            if (valid_in) begin
                if (count == 2'd3) begin
                    // Reached 4th data: mark output pending and reset accumulator and count next cycle
                    accumulator <= accumulator + data_in;
                    output_pending <= 1'b1;
                    count <= 2'd0;
                end else begin
                    accumulator <= accumulator + data_in;
                    count <= count + 1'b1;
                    output_pending <= 1'b0;
                end
            end else begin
                // No valid input, keep state and clear output_pending
                output_pending <= 1'b0;
            end
        end
    end

    // Output logic: valid_out asserted 1 cycle when output_pending is set
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            if (output_pending) begin
                data_out  <= accumulator;
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule