module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    // Gray-coded state machine (00, 01, 11, 10)
    reg [1:0] state;
    reg [3:0] data_reg;
    
    // Gray code state transitions
    wire [1:0] next_state = (state == 2'b10) ? 2'b00 : 
                          (state == 2'b00) ? 2'b01 :
                          (state == 2'b01) ? 2'b11 : 2'b10;

    // State and data register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00;
            data_reg <= 4'b0;
        end else begin
            state <= next_state;
            if (state == 2'b10)  // Last state before wrap
                data_reg <= d;     // Load new data
        end
    end

    // Direct bit selection using barrel shifter approach
    assign dout = (state == 2'b00) ? data_reg[3] :
                 (state == 2'b01) ? data_reg[2] :
                 (state == 2'b11) ? data_reg[1] : data_reg[0];

    assign valid_out = (state == 2'b00);  // Valid on first bit

endmodule