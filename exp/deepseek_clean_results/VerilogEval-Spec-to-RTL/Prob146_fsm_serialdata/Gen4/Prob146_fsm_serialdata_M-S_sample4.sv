module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;
    reg [1:0] state;

    // States
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_byte <= 8'b0;
            done <= 1'b0;
            bit_cnt <= 3'b0;
            shift_reg <= 8'b0;
        end else begin
            done <= 1'b0;  // Default done to 0
            
            case (state)
                IDLE: begin
                    if (~in) begin  // Falling edge detection
                        state <= START;
                    end
                end
                
                START: begin
                    if (in) begin  // False start, go back to IDLE
                        state <= IDLE;
                    end else begin
                        state <= DATA;
                        bit_cnt <= 3'b0;
                    end
                end
                
                DATA: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    if (bit_cnt == 3'd7) begin
                        state <= STOP;
                    end
                    bit_cnt <= bit_cnt + 1;
                end
                
                STOP: begin
                    if (in) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                    // Else stay in STOP until we get valid stop bit
                end
            endcase
        end
    end

endmodule