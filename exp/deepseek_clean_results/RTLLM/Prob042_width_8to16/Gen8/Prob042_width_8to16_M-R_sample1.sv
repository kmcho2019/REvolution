module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output wire valid_out,
    output wire [15:0] data_out
);

reg ready;
reg [7:0] stored_byte;
reg [15:0] output_reg;
reg valid_reg;

// Sequential logic for state and storage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ready <= 1'b0;
        stored_byte <= 8'b0;
        output_reg <= 16'b0;
        valid_reg <= 1'b0;
    end else begin
        valid_reg <= 1'b0; // Default to invalid
        
        if (valid_in) begin
            if (ready) begin
                // Second byte received
                output_reg <= {stored_byte, data_in};
                valid_reg <= 1'b1;
                ready <= 1'b0;
            end else begin
                // First byte received
                stored_byte <= data_in;
                ready <= 1'b1;
            end
        end
    end
end

// Continuous assignments for outputs
assign valid_out = valid_reg;
assign data_out = output_reg;

endmodule