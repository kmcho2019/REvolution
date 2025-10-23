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
    wire terminal_count = (bit_count == 3'd7);
    wire recv_enable = (state == RECEIVE);

    // FSM state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
        end else begin
            state <= next_state;
            
            if (state == IDLE && in == 0) begin
                shift_reg <= 0;  // Prepare to receive new byte
            end
            
            if (recv_enable) begin
                shift_reg <= {in, shift_reg[7:1]};  // Shift in LSB first
                bit_count <= bit_count + 1;
            end else if (state == STOP && in == 1) begin
                out_byte <= shift_reg;
            end
        end
    end

    // Done signal generation (separate for timing)
    always @(posedge clk) begin
        if (reset) begin
            done <= 0;
        end else begin
            done <= (state == STOP && in == 1);
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                next_state = terminal_count ? STOP : RECEIVE;
            end
            
            STOP: begin
                next_state = (in == 1) ? IDLE : ERROR;
            end
            
            ERROR: begin
                next_state = (in == 1) ? IDLE : ERROR;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule