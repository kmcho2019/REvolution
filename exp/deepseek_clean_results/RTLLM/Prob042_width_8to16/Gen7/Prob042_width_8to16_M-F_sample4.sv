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
localparam HAVE_FIRST_BYTE = 1'b1;

reg state;

always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        case (state)
            IDLE: begin
                if (valid_in) begin
                    data_out[15:8] <= data_in;
                    state <= HAVE_FIRST_BYTE;
                end
            end
            
            HAVE_FIRST_BYTE: begin
                if (valid_in) begin
                    data_out[7:0] <= data_in;
                    valid_out <= 1'b1;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule