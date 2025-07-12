module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot state encoding
    localparam IDLE  = 4'b0001,
               START = 4'b0010,
               DATA  = 4'b0100,
               STOP  = 4'b1000,
               ERROR = 4'b1000;  // We'll separate STOP and ERROR by reusing bits with minimal states

    // Since ERROR must be distinct, expand states accordingly:
    // Let's define 5 states for clarity:
    localparam S_IDLE  = 5'b00001;
    localparam S_DATA  = 5'b00010;
    localparam S_STOP  = 5'b00100;
    localparam S_ERROR = 5'b01000;

    reg [4:0] state = S_IDLE;
    reg [2:0] bit_count = 3'd0;
    reg [7:0] shift_reg = 8'd0;

    always @(posedge clk) begin
        if (reset) begin
            state     <= S_IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // Default done low every cycle except when stop bit detected correctly
            case(state)
                S_IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    if (in == 1'b0)
                        state <= S_DATA;
                    else
                        state <= S_IDLE;
                end

                S_DATA: begin
                    shift_reg <= {in, shift_reg[7:1]}; // Shift right for LSB first (shift right, new bit at MSB)
                    if (bit_count == 3'd7) begin
                        state <= S_STOP;
                        bit_count <= 3'd0;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end

                S_STOP: begin
                    if (in == 1'b1) begin
                        done <= 1'b1;
                        state <= S_IDLE;
                    end else begin
                        state <= S_ERROR;
                    end
                end

                S_ERROR: begin
                    if (in == 1'b1)
                        state <= S_IDLE;
                    else
                        state <= S_ERROR;
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                default: begin
                    state <= S_IDLE;
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule