module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding (binary)
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Next state and control signals (combinational)
    wire next_state_IDLE    = (state == STOP && in) || (state == WAIT && in);
    wire next_state_RECEIVE = (state == IDLE && !in) || (state == RECEIVE && bit_count != 3'b111);
    wire next_state_STOP    = (state == RECEIVE && bit_count == 3'b111);
    wire next_state_WAIT    = (state == STOP && !in);

    wire [1:0] next_state = next_state_IDLE    ? IDLE :
                           next_state_RECEIVE ? RECEIVE :
                           next_state_STOP    ? STOP :
                           next_state_WAIT    ? WAIT :
                           IDLE;  // default

    // Shift register control
    wire shift_enable = (state == RECEIVE);
    wire done = (state == STOP && in);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
        end else begin
            state <= next_state;
            
            // Counter logic
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
            
            // Shift register
            if (shift_enable) begin
                shift_reg <= {in, shift_reg[7:1]};  // LSB first
            end
        end
    end

endmodule