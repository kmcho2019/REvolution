module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam BIT0 = 2'b01;
    localparam BIT1 = 2'b10;
    localparam BIT2 = 2'b11;
    localparam BIT3 = 2'b00; // Wraps back to BIT0 after BIT3

    reg [1:0] state, next_state;
    reg [3:0] shift_reg;
    reg valid;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            shift_reg <= 4'b0;
        end else begin
            state <= next_state;
            if (state == IDLE && next_state == BIT0)
                shift_reg <= d; // Capture parallel data
            else if (state != IDLE)
                shift_reg <= {shift_reg[2:0], 1'b0}; // Shift left
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = BIT0; // Always move to BIT0 when not idle
            BIT0: next_state = BIT1;
            BIT1: next_state = BIT2;
            BIT2: next_state = BIT3;
            BIT3: next_state = BIT0;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign valid_out = (state != IDLE);
    assign dout = shift_reg[3]; // MSB is always output

endmodule