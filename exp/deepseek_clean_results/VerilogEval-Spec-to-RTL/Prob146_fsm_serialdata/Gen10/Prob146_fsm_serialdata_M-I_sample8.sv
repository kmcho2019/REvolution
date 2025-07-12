module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states (one-hot encoded)
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg next_done;

    // Registered next_state for better timing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= next_done;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    if (in == 1'b0) begin
                        shift_reg <= 8'b0;
                    end
                end
                
                RECEIVE: begin
                    if (bit_count < 3'b111) begin
                        shift_reg <= {shift_reg[6:0], in};  // Left shift (LSB first)
                        bit_count <= bit_count + 1;
                    end
                end
                
                STOP: begin
                    out_byte <= shift_reg;
                end
            endcase
        end
    end

    // Next state logic (combinational)
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
                    next_state = IDLE;
                    next_done = 1'b1;  // Single-cycle pulse
                end else begin
                    next_state = IDLE;  // Treat missing stop bit as new start
                end
            end
        endcase
    end

endmodule