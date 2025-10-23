module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam IDLE  = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP  = 2'b10;
    localparam ERROR = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    done <= 1'b0;
                    if (in == 1'b0) begin
                        shift_reg <= 8'b0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Shift right (LSB first)
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    out_byte <= shift_reg;
                    done <= (in == 1'b1);  // Assert done only if stop bit is valid
                end
                
                ERROR: begin
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (in == 1'b0) ? RECEIVE : IDLE;
            
            RECEIVE: begin
                if (bit_count == 3'b111) begin
                    next_state = STOP;
                end else begin
                    next_state = RECEIVE;
                end
            end
            
            STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end
            
            ERROR: next_state = (in == 1'b1) ? IDLE : ERROR;
            
            default: next_state = IDLE;
        endcase
    end

endmodule