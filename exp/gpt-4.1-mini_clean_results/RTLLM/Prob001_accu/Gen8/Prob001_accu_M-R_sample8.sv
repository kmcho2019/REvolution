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
    reg       full_flag;

    // Count valid inputs
    always @(posedge clk) begin
        if (!rst_n) begin
            count <= 2'd0;
            full_flag <= 1'b0;
        end else begin
            if (valid_in) begin
                if (count == 2'd3) begin
                    count <= 2'd0;
                    full_flag <= 1'b1;
                end else begin
                    count <= count + 1'b1;
                    full_flag <= 1'b0;
                end
            end else begin
                full_flag <= 1'b0;
            end
        end
    end

    // Accumulate data_in on valid_in
    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
        end else begin
            if (valid_in) begin
                // Clear accumulator at start of new batch (count == 0)
                if (count == 2'd0) begin
                    accumulator <= data_in;
                end else begin
                    accumulator <= accumulator + data_in;
                end
            end
        end
    end

    // Output logic with valid_out pulse
    always @(posedge clk) begin
        if (!rst_n) begin
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            if (full_flag) begin
                data_out  <= accumulator;
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule