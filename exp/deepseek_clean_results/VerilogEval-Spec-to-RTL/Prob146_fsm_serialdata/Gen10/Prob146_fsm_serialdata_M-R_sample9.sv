module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // One-hot state encoding for better timing
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam ERROR   = 4'b1000;
    localparam BIT_COUNT_MAX = 3'd7;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Combinatorial done signal
    assign done = (state == STOP) && (in == 1);

    // Next state function
    function [3:0] get_next_state;
        input [3:0] current_state;
        input in;
        input [2:0] bit_count;
        begin
            case (current_state)
                IDLE:    get_next_state = (in == 0) ? RECEIVE : IDLE;
                RECEIVE: get_next_state = (bit_count == BIT_COUNT_MAX) ? STOP : RECEIVE;
                STOP:    get_next_state = (in == 1) ? IDLE : ERROR;
                ERROR:   get_next_state = (in == 1) ? IDLE : ERROR;
                default: get_next_state = IDLE;
            endcase
        end
    endfunction

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
                    if (in == 0) begin
                        shift_reg <= 0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (in == 1) begin
                        out_byte <= shift_reg;
                    end
                end
                
                ERROR: begin
                    // No action needed in error state
                end
            endcase
        end
    end

    // Continuous assignment for next state
    always @(*) begin
        next_state = get_next_state(state, in, bit_count);
    end

endmodule