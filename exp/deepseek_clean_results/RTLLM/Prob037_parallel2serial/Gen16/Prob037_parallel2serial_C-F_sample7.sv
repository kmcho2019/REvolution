module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    // Gray-coded state (00,01,11,10)
    reg [1:0] state;
    reg [3:0] data_reg;
    
    // Next state logic (simplified Gray code progression)
    wire [1:0] next_state = {state[0], ~(state[1] ^ state[0])};
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00;
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;
            
            // Load new data at end of cycle
            if (state == 2'b10) begin
                data_reg <= d;
                dout <= d[3];  // Output MSB immediately
            end else begin
                dout <= data_reg[2];  // Next bit
                data_reg <= {data_reg[2:0], 1'b0};  // Shift left
            end
            
            // Valid one cycle early for better timing
            valid_out <= (next_state == 2'b00);
        end
    end

endmodule