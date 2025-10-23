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
    reg [3:0] bit_count;  // Counts 0-8 (4 bits)
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;  // Default done to 0
            
            case (state)
                IDLE: begin
                    if (!in) begin  // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 0;
                        shift_reg <= 0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                    
                    if (bit_count == 7) begin  // Received all 8 bits
                        state <= STOP;
                    end
                end
                
                STOP: begin
                    if (in) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1;
                        state <= IDLE;
                    end
                    // Else stay in STOP until valid stop bit
                end
            endcase
        end
    end

endmodule