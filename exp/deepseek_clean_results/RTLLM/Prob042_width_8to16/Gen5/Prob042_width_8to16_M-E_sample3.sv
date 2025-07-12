module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Pipeline registers
reg [7:0] stage1_data;
reg stage1_valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all registers on reset
        stage1_data <= 8'b0;
        stage1_valid <= 1'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        // Pipeline stage 1: Capture first byte
        if (valid_in) begin
            stage1_data <= data_in;
            stage1_valid <= 1'b1;
        end else begin
            stage1_valid <= 1'b0;
        end

        // Pipeline stage 2: Concatenate and output
        if (stage1_valid && valid_in) begin
            data_out <= {stage1_data, data_in};
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule