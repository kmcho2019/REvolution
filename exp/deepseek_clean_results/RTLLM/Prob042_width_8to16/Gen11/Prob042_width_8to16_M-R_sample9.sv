module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Control signals
reg has_first_byte;
reg [7:0] stored_byte;

// Next state logic
wire next_has_first_byte;
wire load_output;

assign next_has_first_byte = (!has_first_byte && valid_in) || 
                            (has_first_byte && !valid_in);
assign load_output = has_first_byte && valid_in;

// Data path
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        has_first_byte <= 1'b0;
        stored_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Store first byte when valid and no stored byte
        if (valid_in && !has_first_byte) begin
            stored_byte <= data_in;
        end

        // Update state
        has_first_byte <= next_has_first_byte;

        // Generate output when we have both bytes
        if (load_output) begin
            data_out <= {stored_byte, data_in};
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule