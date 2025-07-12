module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    // Gray-coded state (00, 01, 11, 10)
    reg [1:0] state;
    reg [3:0] data_reg;
    
    // Optimized state transitions
    wire [1:0] next_state = {state[0], ~state[1] ^ state[0]};
    wire load = (state == 2'b10);  // Load new data at last state

    // State and data register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00;
            data_reg <= 4'b0;
        end else begin
            state <= next_state;
            if (load)
                data_reg <= d;
        end
    end

    // Optimized bit selection
    assign dout = data_reg[3 - state];  // Direct bit selection
    assign valid_out = (state == 2'b00);  // Valid on first bit

endmodule