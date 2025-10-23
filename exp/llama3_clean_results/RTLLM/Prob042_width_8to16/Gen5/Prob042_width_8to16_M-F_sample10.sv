module width_8to16 (
    input         clk,
    input         rst_n,
    input         valid_in,
    input  [7:0]  data_in,
    output        valid_out,
    output [15:0] data_out
);

// Registers
reg [7:0]  data_lock;
reg         data_valid;
reg         valid_out_reg;
reg [15:0] data_out_reg;

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset logic
        data_lock <= 8'd0;
        data_valid <= 1'b0;
        valid_out_reg <= 1'b0;
        data_out_reg <= 16'd0;
    end else begin
        // Default assignments to avoid latches
        valid_out_reg <= valid_out_reg;
        data_out_reg <= data_out_reg;
        data_valid <= data_valid;
        data_lock <= data_lock;

        // Store the first valid data
        if (valid_in && !data_valid) begin
            data_lock <= data_in;
            data_valid <= 1'b1;
        end
        
        // Generate output when the second valid data arrives
        if (valid_in && data_valid) begin
            data_out_reg <= {data_lock, data_in};
            valid_out_reg <= 1'b1;
            data_valid <= 1'b0;
        end
        
        // Reset valid_out_reg when output is not valid and input is not valid
        if (!valid_in && valid_out_reg) begin
            valid_out_reg <= 1'b0;
        end
    end
end

// Continuous assignments for outputs
assign valid_out = valid_out_reg;
assign data_out  = data_out_reg;

endmodule