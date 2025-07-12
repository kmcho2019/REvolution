module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State encoding
localparam IDLE = 1'b0;
localparam GOT_FIRST_BYTE = 1'b1;

reg state;
reg [7:0] stored_byte;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        stored_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default output (no assignment to valid_out)
        valid_out <= 1'b0;
        
        case (state)
            IDLE: begin
                if (valid_in) begin
                    stored_byte <= data_in;
                    state <= GOT_FIRST_BYTE;
                end
            end
            
            GOT_FIRST_BYTE: begin
                if (valid_in) begin
                    data_out <= {stored_byte, data_in};
                    valid_out <= 1'b1;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule