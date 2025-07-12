module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State definitions
localparam WAIT_FIRST = 1'b0;
localparam WAIT_SECOND = 1'b1;

reg state;
reg [7:0] first_byte;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        state <= WAIT_FIRST;
        first_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        case (state)
            WAIT_FIRST: begin
                if (valid_in) begin
                    first_byte <= data_in;
                    state <= WAIT_SECOND;
                end
            end
            
            WAIT_SECOND: begin
                if (valid_in) begin
                    data_out <= {first_byte, data_in};
                    valid_out <= 1'b1;
                    state <= WAIT_FIRST;
                end
            end
        endcase
    end
end

endmodule