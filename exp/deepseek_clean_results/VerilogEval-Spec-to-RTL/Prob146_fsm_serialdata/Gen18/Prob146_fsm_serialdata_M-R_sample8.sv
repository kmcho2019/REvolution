module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded states
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state;
    reg [3:0] bit_count;  // Count to 8 (4 bits)
    reg [7:0] shift_reg;

    // Next state logic (combinational)
    wire next_idle    = (state == IDLE)    & ~in |
                       (state == STOP)     & in;
    wire next_receive = (state == IDLE)    & ~in |
                       (state == RECEIVE)  & (bit_count < 8);
    wire next_stop    = (state == RECEIVE) & (bit_count == 8);

    // State transition (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;
            
            case (1'b1)  // Synthesis will optimize this
                next_idle: begin
                    state <= IDLE;
                    bit_count <= 0;
                    if (state == STOP && in) begin
                        out_byte <= shift_reg;
                        done <= 1;
                    end
                end
                
                next_receive: begin
                    state <= RECEIVE;
                    if (state == IDLE) begin
                        shift_reg <= 0;
                        bit_count <= 0;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                
                next_stop: begin
                    state <= STOP;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

    // Shift register update (sequential)
    always @(posedge clk) begin
        if (~reset && state == RECEIVE) begin
            shift_reg <= {in, shift_reg[7:1]};  // LSB first
        end
    end

endmodule