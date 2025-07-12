module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [15:0] data_accum;
reg ready;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_accum <= 16'b0;
        ready <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        // Shift in new data when valid
        if (valid_in) begin
            if (ready) begin
                // We have a complete word - output it
                data_out <= {data_accum[7:0], data_in};
                valid_out <= 1'b1;
                ready <= 1'b0;
            end else begin
                // Store first byte and mark ready
                data_accum <= {8'b0, data_in};
                ready <= 1'b1;
            end
        end
    end
end

endmodule