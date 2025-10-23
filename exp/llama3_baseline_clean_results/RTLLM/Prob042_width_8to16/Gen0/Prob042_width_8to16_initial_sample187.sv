module width_8to16 (
    input         clk,
    input         rst_n,
    input         valid_in,
    input  [7:0]  data_in,
    output        valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock; // Register to store the first valid data
reg [7:0] data_current; // Register to store the current valid data
reg        flag; // Flag to indicate if data_lock has valid data
reg        valid_out_reg; // Register for valid_out output
reg [15:0] data_out_reg; // Register for data_out output

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Reset condition
        data_out_reg <= 16'b0;
        valid_out_reg <= 1'b0;
        flag <= 1'b0;
        data_lock <= 8'b0;
    end else begin
        if (valid_in && !flag) begin // First valid data
            data_lock <= data_in;
            flag <= 1'b1;
        end else if (valid_in && flag) begin // Second valid data
            data_out_reg <= {data_lock, data_in};
            valid_out_reg <= 1'b1;
            flag <= 1'b0; // Reset flag after generating output
        end else begin
            valid_out_reg <= 1'b0;
            data_out_reg <= data_out_reg; // Hold the previous output
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule