module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    reg [1:0] state;
    localparam IDLE = 2'b00;
    localparam DATA = 2'b01;
    localparam STOP = 2'b10;

    // Bit counter and data register
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;  // Default to not done
            
            case (state)
                IDLE: begin
                    if (in == 0) begin  // Start bit detected
                        state <= DATA;
                        bit_count <= 0;
                        data_reg <= 0;
                    end
                end
                
                DATA: begin
                    data_reg <= {in, data_reg[7:1]};  // Shift in LSB first
                    if (bit_count == 7) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                
                STOP: begin
                    if (in == 1) begin  // Valid stop bit
                        out_byte <= data_reg;
                        done <= 1;
                        state <= IDLE;
                    end
                    // Else stay in STOP until we see a 1
                end
            endcase
        end
    end

endmodule