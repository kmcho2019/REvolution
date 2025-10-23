module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    // Gray-coded state encoding for low power
    localparam [3:0] STATE_0 = 4'b0001,
                     STATE_1 = 4'b0011,
                     STATE_2 = 4'b0010,
                     STATE_3 = 4'b0110;

    reg [3:0] state, next_state;
    reg [3:0] data_reg;

    // One-hot state transitions with Gray coding
    always @(*) begin
        case (state)
            STATE_0: next_state = STATE_1;
            STATE_1: next_state = STATE_2;
            STATE_2: next_state = STATE_3;
            STATE_3: next_state = STATE_0;
            default: next_state = STATE_0;
        endcase
    end

    // State and data register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= STATE_0;
            data_reg <= 4'b0;
        end else begin
            state <= next_state;
            if (state == STATE_3)
                data_reg <= d;  // Load new data when wrapping around
        end
    end

    // Optimized output assignments
    assign valid_out = (state == STATE_0);
    assign dout = |(data_reg & 4'b1000) ? 1'b1 : 1'b0;  // MSB first

    // Dynamic bit selection using state
    always @(*) begin
        case (state)
            STATE_0: dout = data_reg[3];
            STATE_1: dout = data_reg[2];
            STATE_2: dout = data_reg[1];
            STATE_3: dout = data_reg[0];
            default: dout = 1'b0;
        endcase
    end

endmodule