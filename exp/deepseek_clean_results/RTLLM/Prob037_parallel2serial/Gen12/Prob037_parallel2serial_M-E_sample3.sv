module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data_buffer;
    reg [1:0] cnt;
    reg pre_valid;
    
    // Next counter value (modulo 4 down-counter)
    wire [1:0] next_cnt = (cnt == 2'b00) ? 2'b11 : (cnt - 1'b1);
    
    // Bit selection mux
    wire current_bit = data_buffer[cnt];
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b11;       // Start at last position
            data_buffer <= 4'b0;
            valid_out <= 1'b0;
            pre_valid <= 1'b0;
            dout <= 1'b0;
        end else begin
            // Update counter
            cnt <= next_cnt;
            
            // Load new data when wrapping around
            if (cnt == 2'b00) begin
                data_buffer <= d;
            end
            
            // Generate pre-valid signal (one cycle early)
            pre_valid <= (next_cnt == 2'b00);
            
            // Register outputs
            valid_out <= pre_valid;
            dout <= current_bit;
        end
    end

endmodule