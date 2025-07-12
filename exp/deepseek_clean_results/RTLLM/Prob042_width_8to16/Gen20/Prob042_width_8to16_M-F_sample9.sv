module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg has_first;
reg [7:0] first_byte;
reg next_valid_out;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        has_first <= 1'b0;
        first_byte <= 8'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
        next_valid_out <= 1'b0;
    end else begin
        // Store first byte when valid and no previous byte stored
        if (valid_in && !has_first) begin
            first_byte <= data_in;
            has_first <= 1'b1;
            next_valid_out <= 1'b0;
        end
        // Generate output when second byte arrives
        else if (valid_in && has_first) begin
            data_out <= {first_byte, data_in};
            has_first <= 1'b0;
            next_valid_out <= 1'b1;
        end else begin
            next_valid_out <= 1'b0;
        end
        
        // Register the valid_out signal one cycle after data concatenation
        valid_out <= next_valid_out;
    end
end

endmodule