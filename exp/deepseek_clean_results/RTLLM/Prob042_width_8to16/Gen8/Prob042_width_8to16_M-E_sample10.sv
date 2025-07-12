module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State definition
localparam IDLE  = 1'b0;
localparam READY = 1'b1;

reg state;
reg [7:0] data_hold;  // Storage for first byte
reg have_first;       // Flag indicating first byte is stored

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_hold <= 8'b0;
        have_first <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        // State machine and data capture
        case (state)
            IDLE: begin
                if (valid_in) begin
                    data_hold <= data_in;  // Store first byte
                    have_first <= 1'b1;
                    state <= READY;
                end
            end
            
            READY: begin
                if (valid_in) begin
                    // Combine stored byte with new byte
                    data_out <= {data_hold, data_in};
                    valid_out <= 1'b1;
                    have_first <= 1'b0;
                    state <= IDLE;
                end else begin
                    // Maintain state waiting for second byte
                    state <= READY;
                end
            end
        endcase
    end
end

endmodule