module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] state, next_state;
    reg [3:0] data_reg;
    wire [1:0] state_plus_1 = state + 1'b1;

    // State transitions
    always @(*) begin
        if (state == 2'b11)
            next_state = 2'b00;  // Wrap around after state 3
        else
            next_state = state_plus_1;
    end

    // State and data register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b0;
            data_reg <= 4'b0;
        end else begin
            state <= next_state;
            if (state == 2'b11)
                data_reg <= d;  // Load new data when wrapping around
        end
    end

    // Output assignments
    assign valid_out = (state == 2'b00);
    assign dout = data_reg[3 - state];  // MSB first (state 0 outputs bit 3)

endmodule