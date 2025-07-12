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
localparam FIRST = 1'b1;

reg state;
reg [7:0] first_data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        first_data <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default to not valid
        
        case (state)
            IDLE: begin
                if (valid_in) begin
                    first_data <= data_in;
                    state <= FIRST;
                end
            end
            
            FIRST: begin
                if (valid_in) begin
                    data_out <= {first_data, data_in};
                    valid_out <= 1'b1;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule