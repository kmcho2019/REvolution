module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam IDLE   = 0;
    localparam RECEIVE = 1;
    localparam STOP   = 2;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;  // Default to not done
            
            case (state)
                IDLE: begin
                    if (!in) begin  // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 0;
                        shift_reg <= 0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Shift in LSB first
                    
                    if (bit_count == 3'b111) begin  // After 8 bits
                        state <= STOP;
                    end
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (in) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1;
                        state <= IDLE;
                    end else begin
                        state <= STOP;  // Wait for stop bit
                    end
                end
            endcase
        end
    end

endmodule