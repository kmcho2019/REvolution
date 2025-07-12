module pulse_detect (
    input clk,
    input rst_n,
    input data_in,          // Potentially asynchronous
    output reg data_out
);

// Metastability protection (2-stage synchronizer)
reg [1:0] sync_reg;
wire sync_data_in;

// Clock gating control
reg last_data_in;
wire data_changed = (last_data_in != data_in);
wire clk_enable = data_changed;

// Pattern detection
reg [2:0] pattern_buffer;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sync_reg <= 2'b00;
        last_data_in <= 1'b0;
        pattern_buffer <= 3'b000;
        data_out <= 1'b0;
    end else begin
        // Synchronizer chain
        sync_reg <= {sync_reg[0], data_in};
        
        // Clock gating control
        last_data_in <= sync_data_in;
        
        // Clock-gated pattern buffer
        if (clk_enable) begin
            pattern_buffer <= {pattern_buffer[1:0], sync_data_in};
        end
        
        // Pattern detection (same as original)
        data_out <= (pattern_buffer == 3'b010);
    end
end

assign sync_data_in = sync_reg[1];

endmodule