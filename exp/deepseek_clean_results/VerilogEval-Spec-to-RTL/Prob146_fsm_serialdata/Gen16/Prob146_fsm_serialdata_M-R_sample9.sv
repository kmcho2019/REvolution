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
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_reg;

    // Continuous assignment for done output
    assign done = done_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b111;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            done_reg <= 1'b0;  // Default value

            case (state)
                IDLE: begin
                    if (!in) begin
                        shift_reg <= 8'b0;
                        bit_count <= 3'b111;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count - 1;
                end
                
                STOP: begin
                    if (in) begin
                        out_byte <= shift_reg;
                        done_reg <= 1'b1;
                    end
                end
            endcase
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = state;
        
        case (state)
            IDLE: begin
                if (!in) begin
                    next_state = RECEIVE;
                end
            end
            
            RECEIVE: begin
                if (bit_count == 3'b0) begin
                    next_state = STOP;
                end
            end
            
            STOP: begin
                if (in) begin
                    next_state = IDLE;
                end else begin
                    next_state = IDLE;  // Wait for stop bit
                end
            end
        endcase
    end

endmodule