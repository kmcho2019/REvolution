module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    // Optimized Gray code counter (00, 01, 11, 10)
    reg [1:0] state;
    reg [3:0] data_reg;

    // Next state logic (simplified Gray code progression)
    wire [1:0] next_state = (state == 2'b10) ? 2'b00 : {state[0], ~state[1]};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00;
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            // Update state machine
            state <= next_state;
            
            // Data handling
            if (state == 2'b10) begin  // Last state before wrap
                data_reg <= d;         // Load new parallel data
                dout <= d[3];          // Output MSB immediately
            end else begin
                dout <= data_reg[3-state];  // Direct bit selection
            end
            
            // Valid generation (registered for better timing)
            valid_out <= (next_state == 2'b00);
        end
    end

endmodule