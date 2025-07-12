module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Simplified state encoding
    localparam IDLE   = 2'd0;
    localparam RECEIVE = 2'd1;
    localparam STOP   = 2'd2;

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
            done <= 0;  // Default value
            
            case (state)
                IDLE: begin
                    if (in == 0) begin  // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 0;
                        shift_reg <= 0;
                    end
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    if (bit_count == 3'b111) begin  // After 8 bits
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end

                STOP: begin
                    if (in == 1) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1;
                        state <= IDLE;
                    end
                    // Else stay in STOP until stop bit found
                end
            endcase
        end
    end

endmodule