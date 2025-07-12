module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    // Moore FSM states - 3 states now (merged ERROR into IDLE)
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state, next_state;
    reg [7:0] bit_enable;  // One-hot bit counter
    reg [7:0] shift_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_enable <= 8'b00000001;  // Initialize to first bit
            shift_reg <= 0;
        end else begin
            state <= next_state;
            
            if (state == RECEIVE) begin
                if (bit_enable != 8'b10000000) begin
                    bit_enable <= bit_enable << 1;  // Shift left for next bit
                end
                if (in) begin  // Only shift when input is valid
                    shift_reg <= {in, shift_reg[7:1]};
                end
            end else if (state == IDLE) begin
                bit_enable <= 8'b00000001;  // Reset for new byte
            end
        end
    end

    // Next state logic (purely combinatorial)
    always @(*) begin
        case (state)
            IDLE:    next_state = (in == 0) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_enable == 8'b10000000) ? STOP : RECEIVE;
            STOP:    next_state = (in == 1) ? IDLE : STOP;  // Wait for valid stop bit
            default: next_state = IDLE;
        endcase
    end

    // Output assignments (combinational)
    assign done = (state == STOP) && (in == 1);
    assign out_byte = (state == STOP) ? shift_reg : 8'b0;

endmodule