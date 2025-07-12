module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] stored_byte;
reg [1:0] state;
reg ready_to_output;

// State encoding
localparam IDLE      = 2'b00;
localparam HAS_FIRST = 2'b01;
localparam HAS_BOTH  = 2'b10;

always @(posedge clk) begin
    if (!rst_n) begin
        // Synchronous reset
        stored_byte <= 8'b0;
        state <= IDLE;
        valid_out <= 1'b0;
        data_out <= 16'b0;
        ready_to_output <= 1'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        case (state)
            IDLE: begin
                if (valid_in) begin
                    stored_byte <= data_in;
                    state <= HAS_FIRST;
                end
            end
            
            HAS_FIRST: begin
                if (valid_in) begin
                    data_out <= {stored_byte, data_in};
                    state <= HAS_BOTH;
                    ready_to_output <= 1'b1;
                end
            end
            
            HAS_BOTH: begin
                if (ready_to_output) begin
                    valid_out <= 1'b1;
                    ready_to_output <= 1'b0;
                    state <= IDLE;
                end
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule