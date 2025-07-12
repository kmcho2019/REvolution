module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output wire dout
);

    // Gray-coded counter (00, 01, 11, 10)
    reg [1:0] state;
    reg [3:0] data_reg;
    
    // Next state logic (simplified Gray code progression)
    wire [1:0] next_state = {state[0], ~(state[1] ^ state[0])};
    
    // Output selection
    assign dout = data_reg[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00;
            data_reg <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;
            
            if (state == 2'b10) begin  // Last state before wrap
                data_reg <= d;         // Load new parallel data
                valid_out <= 1'b1;     // Valid on next cycle (first bit)
            end else begin
                data_reg <= {data_reg[2:0], 1'b0};  // Shift left
                valid_out <= 1'b0;     // Not valid during shifting
            end
        end
    end

endmodule