module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        done <= 1'b0;  // Default done to 0 (one-cycle pulse)
        
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (!in) begin  // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 0;
                        shift_reg <= 0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {shift_reg[6:0], in};  // Left shift (LSB first)
                    if (bit_count == 7) begin
                        state <= STOP;
                    end
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (in) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin  // Missing stop bit
                        state <= IDLE;  // Wait for next start bit
                    end
                end
            endcase
        end
    end

endmodule