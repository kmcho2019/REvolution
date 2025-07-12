module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot FSM states
    localparam IDLE    = 2'b01;
    localparam RECEIVE = 2'b10;
    localparam STOP    = 2'b00;  // Not strictly one-hot but simpler for this case

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg next_done;

    // Registered next_state to improve timing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= next_done;
            
            if (state == RECEIVE) begin
                shift_reg <= {shift_reg[6:0], in};  // Left shift (MSB first)
                bit_count <= bit_count + 1;
            end else if (state == IDLE && in == 1'b0) begin
                shift_reg <= 8'b0;  // Prepare for new byte
                bit_count <= 3'b0;
            end
        end
    end

    // Combinational next state and output logic
    always @(*) begin
        next_state = state;
        next_done = 1'b0;
        
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = RECEIVE;
                end
            end
            
            RECEIVE: begin
                if (bit_count == 3'b111) begin
                    next_state = STOP;
                end
            end
            
            STOP: begin
                if (in == 1'b1) begin
                    next_done = 1'b1;
                    out_byte = shift_reg;
                    next_state = IDLE;
                end else begin
                    // Wait for stop bit (implicitly stays in STOP)
                    // Could transition to IDLE here if error recovery not needed
                end
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule