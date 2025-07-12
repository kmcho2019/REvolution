module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // FSM states - optimized 2-bit encoding
    localparam WAIT   = 2'b00;  // Combined IDLE/ERROR when waiting for start
    localparam RECV   = 2'b01;  // Receiving data bits
    localparam STOP   = 2'b10;  // Checking stop bit

    reg [1:0] state, next_state;
    reg [7:0] shift_reg;
    reg [3:0] bit_count;  // Count 0-8 for simpler comparison
    reg shift_en;         // Shift register enable

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT;
            shift_reg <= 8'b0;
            bit_count <= 4'b0;
        end else begin
            state <= next_state;
            
            if (shift_en) begin
                shift_reg <= {in, shift_reg[7:1]};  // LSB-first shift
                bit_count <= bit_count + 1;
            end else if (state == WAIT && in == 0) begin
                bit_count <= 4'b0;  // Reset counter at start bit
            end
        end
    end

    // Next state and control logic
    always @(*) begin
        shift_en = 0;
        case (state)
            WAIT: begin
                next_state = (in == 0) ? RECV : WAIT;
            end
            RECV: begin
                shift_en = 1;
                next_state = (bit_count == 8) ? STOP : RECV;
            end
            STOP: begin
                next_state = (in == 1) ? WAIT : WAIT;  // Always return to WAIT
                if (in == 1) begin
                    out_byte = shift_reg;  // Update output when valid stop
                end
            end
            default: next_state = WAIT;
        endcase
    end

    // Combinational done signal - asserted only in STOP state with valid stop bit
    assign done = (state == STOP) && (in == 1);

endmodule