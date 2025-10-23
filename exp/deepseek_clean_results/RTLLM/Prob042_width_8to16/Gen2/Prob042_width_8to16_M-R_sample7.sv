module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] stored_data;
reg has_first_half;

wire [15:0] next_data_out;
wire next_valid_out;

// Combinational logic for next outputs
assign next_data_out = {stored_data, data_in};
assign next_valid_out = has_first_half & valid_in;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stored_data <= 8'b0;
        has_first_half <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end
    else begin
        // Store first half when valid and no stored data
        if (valid_in && !has_first_half) begin
            stored_data <= data_in;
            has_first_half <= 1'b1;
        end
        // Clear storage when completing a pair
        else if (valid_in && has_first_half) begin
            has_first_half <= 1'b0;
        end

        // Register outputs
        valid_out <= next_valid_out;
        if (next_valid_out) begin
            data_out <= next_data_out;
        end
    end
end

endmodule