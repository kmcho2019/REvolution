module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded FSM states
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    
    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b111;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
            shift_enable <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    shift_enable <= 0;
                    if (~in) begin // Start bit detected (active low)
                        state <= RECEIVE;
                        bit_count <= 3'b111;
                        shift_enable <= 1;
                    end
                end
                
                RECEIVE: begin
                    if (shift_enable) begin
                        shift_reg <= {in, shift_reg[7:1]}; // LSB first
                    end
                    
                    if (bit_count == 0) begin
                        state <= STOP;
                        shift_enable <= 0;
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end
                
                STOP: begin
                    if (in) begin // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1;
                        state <= IDLE;
                    end
                    // Stay in STOP until we get a stop bit
                end
            endcase
        end
    end

endmodule