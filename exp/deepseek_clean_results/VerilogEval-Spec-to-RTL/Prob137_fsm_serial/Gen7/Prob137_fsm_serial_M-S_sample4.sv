module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    typedef enum logic [1:0] {
        IDLE,      // Waiting for start bit
        RECEIVE,   // Receiving 8 data bits
        STOP       // Checking stop bit
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count <= 0;
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    // No operations needed
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE: next_state = !in ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
            STOP: next_state = in ? IDLE : STOP;
            default: next_state = IDLE;
        endcase
    end

    assign done = (state == STOP) && in;

endmodule