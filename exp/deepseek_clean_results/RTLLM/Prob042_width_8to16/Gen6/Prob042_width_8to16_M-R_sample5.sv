module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Internal registers
reg [7:0] data_hold;    // Stores first byte
reg has_first_byte;      // Flag indicating first byte captured
reg [7:0] next_byte;     // Buffer for second byte
reg output_pending;      // Indicates output should be generated next cycle

// Combinational output (could be made sequential if needed)
always @(*) begin
    valid_out = output_pending;
    data_out = {data_hold, next_byte};
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        data_hold <= 8'b0;
        has_first_byte <= 1'b0;
        next_byte <= 8'b0;
        output_pending <= 1'b0;
    end else begin
        // Clear output flag every cycle (pulse lasts one cycle)
        output_pending <= 1'b0;

        if (valid_in) begin
            if (!has_first_byte) begin
                // Capture first byte
                data_hold <= data_in;
                has_first_byte <= 1'b1;
            end else begin
                // Capture second byte and schedule output
                next_byte <= data_in;
                output_pending <= 1'b1;
                has_first_byte <= 1'b0;  // Clear flag for next pair
            end
        end
    end
end

endmodule