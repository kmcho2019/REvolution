module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] buffer_0, buffer_1;
reg valid_0, valid_1;
reg write_sel;  // 0 for buffer_0, 1 for buffer_1

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        buffer_0 <= 8'b0;
        buffer_1 <= 8'b0;
        valid_0 <= 1'b0;
        valid_1 <= 1'b0;
        write_sel <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;

        // Input handling
        if (valid_in) begin
            if (!write_sel) begin
                buffer_0 <= data_in;
                valid_0 <= 1'b1;
            end else begin
                buffer_1 <= data_in;
                valid_1 <= 1'b1;
            end
            write_sel <= ~write_sel;
        end

        // Output generation when both buffers have data
        if (valid_0 && valid_1) begin
            data_out <= {buffer_0, buffer_1};
            valid_out <= 1'b1;
            valid_0 <= 1'b0;
            valid_1 <= 1'b0;
        end
    end
end

endmodule