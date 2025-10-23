module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Pipeline stages
reg [7:0] stage1_reg;
reg stage1_valid;

// State encoding
localparam IDLE = 2'b00;
localparam HAS_FIRST = 2'b01;
localparam OUTPUT_READY = 2'b10;
reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        stage1_reg <= 8'b0;
        stage1_valid <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (valid_in) begin
                    // Store first byte and move to waiting state
                    stage1_reg <= data_in;
                    stage1_valid <= 1'b1;
                    state <= HAS_FIRST;
                end
                valid_out <= 1'b0;
            end
            
            HAS_FIRST: begin
                if (valid_in) begin
                    // Combine with new byte and output
                    data_out <= {stage1_reg, data_in};
                    valid_out <= 1'b1;
                    state <= OUTPUT_READY;
                end else begin
                    valid_out <= 1'b0;
                end
            end
            
            OUTPUT_READY: begin
                // Return to idle after one cycle
                valid_out <= 1'b0;
                if (valid_in) begin
                    // Start new conversion immediately if data available
                    stage1_reg <= data_in;
                    state <= HAS_FIRST;
                end else begin
                    state <= IDLE;
                end
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule