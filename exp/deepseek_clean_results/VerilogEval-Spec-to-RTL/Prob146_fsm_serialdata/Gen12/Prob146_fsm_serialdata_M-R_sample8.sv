module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // Binary encoded FSM states
    localparam IDLE   = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP   = 2'b10;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg;
    reg done_reg;

    assign done = done_reg;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
            out_byte <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            
            // Shift register operation
            if (state == RECEIVE) begin
                shift_reg <= {in, shift_reg[7:1]};
            end
            
            // Capture output and generate done pulse
            if (next_state == IDLE && state == STOP && in) begin
                out_byte <= shift_reg;
                done_reg <= 1;
            end else begin
                done_reg <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = in ? IDLE : RECEIVE;
            end
            
            RECEIVE: begin
                next_state = (shift_reg[0] !== 1'bx) ? STOP : RECEIVE;
            end
            
            STOP: begin
                next_state = in ? IDLE : STOP;
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule