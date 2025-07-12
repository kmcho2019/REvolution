module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Storage register with valid bit
reg [8:0] storage; // {valid, data[7:0]}

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        storage <= 9'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Clear valid_out if not generating output this cycle
        valid_out <= 1'b0;

        // Store first byte when valid and no stored byte
        if (valid_in && !storage[8]) begin
            storage <= {1'b1, data_in};
        end
        // Generate output when we have stored byte and new valid input
        else if (valid_in && storage[8]) begin
            data_out <= {storage[7:0], data_in};
            valid_out <= 1'b1;
            storage <= 9'b0; // Clear storage after use
        end
    end
end

endmodule