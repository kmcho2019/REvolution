module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam [3:0] 
        IDLE   = 4'b0001,
        RECEIVE = 4'b0010,
        STOP    = 4'b0100;
        // WAIT state removed - handled in STOP state

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Combinational output
    assign done = (state == STOP) && in;

    // State transition logic
    always @(*) begin
        next_state = state;
        case (1'b1) // synthesis parallel_case
            state[0]: // IDLE
                if (~in) next_state = RECEIVE;
            
            state[1]: // RECEIVE
                if (bit_count == 3'd7) 
                    next_state = STOP;
            
            state[2]: // STOP
                if (in) 
                    next_state = IDLE;
                // else stay in STOP (replaces WAIT functionality)
        endcase
    end

    // State register and data path
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            state <= next_state;
            
            case (next_state)
                IDLE: begin
                    bit_count <= 3'd0;
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 3'd1;
                end
                
                STOP: begin
                    // No operations needed
                end
            endcase
        end
    end

endmodule