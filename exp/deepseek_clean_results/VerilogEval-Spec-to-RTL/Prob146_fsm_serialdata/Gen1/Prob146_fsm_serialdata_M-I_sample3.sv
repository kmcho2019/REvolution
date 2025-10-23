module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot FSM states
    localparam IDLE   = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP   = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // FSM state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // Default done to 0
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    if (in == 1'b0) begin  // Start bit detected
                        shift_reg <= 8'b0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {shift_reg[6:0], in};  // Shift in LSB first
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (in == 1'b1) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;       // Assert done for one cycle
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
                
            RECEIVE:
                next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
                
            STOP:
                next_state = (in == 1'b1) ? IDLE : STOP;
                
            default:
                next_state = IDLE;
        endcase
    end

endmodule