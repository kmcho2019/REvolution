module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    // ERROR state merged into STOP

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_reg;
    wire shift_enable;

    assign shift_enable = (state == RECEIVE);

    // State transition and data path
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            
            // Clear done only when needed
            if (done_reg) done_reg <= 1'b0;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    if (in == 1'b0) begin
                        shift_reg <= 8'b0;
                    end
                end

                RECEIVE: begin
                    if (shift_enable) begin
                        shift_reg <= {in, shift_reg[7:1]};
                        bit_count <= bit_count + 1;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin
                        done_reg <= 1'b1;
                    end
                end
            endcase
        end
    end

    // Next state logic - simplified with merged ERROR state
    always @(*) begin
        next_state = state; // Default to current state
        
        case (state)
            IDLE: begin
                if (in == 1'b0) next_state = RECEIVE;
            end

            RECEIVE: begin
                if (bit_count == 3'b111) next_state = STOP;
            end

            STOP: begin
                if (in == 1'b1) next_state = IDLE;
                // Otherwise stay in STOP (equivalent to ERROR)
            end
        endcase
    end

    assign done = done_reg;

endmodule