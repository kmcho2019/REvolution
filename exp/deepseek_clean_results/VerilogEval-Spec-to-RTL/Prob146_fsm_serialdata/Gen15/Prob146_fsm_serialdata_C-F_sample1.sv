module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states - 2-bit encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam ERROR   = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b111; // Initialize to 7 (count down)
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // Default to 0
            
            case (state)
                IDLE: begin
                    if (!in) begin // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 3'b111;
                        shift_reg <= 8'b0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]}; // Right shift for LSB first
                    if (bit_count == 3'b0) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end
                
                STOP: begin
                    if (in) begin // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin // Missing stop bit
                        state <= ERROR;
                    end
                end
                
                ERROR: begin
                    if (in) begin // Found stop bit
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule