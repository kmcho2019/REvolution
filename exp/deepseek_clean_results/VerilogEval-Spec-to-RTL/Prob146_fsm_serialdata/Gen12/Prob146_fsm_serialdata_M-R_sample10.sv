module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // FSM states - optimized 2-bit encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Continuous assignment for shift operation
    wire [7:0] next_shift = {in, shift_reg[7:1]};

    // Combinational done signal
    assign done = (state == STOP) && in;

    // State transition and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (!in) begin
                        shift_reg <= 0;  // Prepare for new reception
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= next_shift;
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (in) begin
                        out_byte <= shift_reg;  // Only update when valid stop bit
                    end
                end
            endcase
        end
    end

    // Optimized next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = (!in) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
            STOP:    next_state = in ? IDLE : STOP;
            default: next_state = IDLE;
        endcase
    end

endmodule