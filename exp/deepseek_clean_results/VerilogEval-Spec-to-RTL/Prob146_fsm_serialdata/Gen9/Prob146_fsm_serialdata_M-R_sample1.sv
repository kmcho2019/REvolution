module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded FSM states
    localparam IDLE   = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP   = 4'b0100;
    localparam ERROR  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;

    // FSM state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
        end else begin
            state <= next_state;
            
            if (state == IDLE && in == 0) begin
                shift_reg <= 0;  // Clear shift register at start bit
            end
            
            if (shift_enable) begin
                shift_reg <= {in, shift_reg[7:1]};  // Shift in LSB first
                bit_count <= bit_count + 1;
            end
            
            if (state == IDLE) begin
                bit_count <= 0;
            end
        end
    end

    // FSM next state logic
    always @(*) begin
        next_state = state;
        shift_enable = 0;
        
        case (1'b1)  // Synthesis will recognize this as one-hot
            state[0]: begin  // IDLE
                if (in == 0) begin
                    next_state = RECEIVE;
                end
            end
            
            state[1]: begin  // RECEIVE
                shift_enable = 1;
                if (bit_count == 7) begin
                    next_state = STOP;
                end
            end
            
            state[2]: begin  // STOP
                if (in == 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end
            
            state[3]: begin  // ERROR
                if (in == 1) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Output logic
    always @(*) begin
        done = (state == STOP && in == 1);
        out_byte = (done) ? shift_reg : 8'b0;
    end

endmodule