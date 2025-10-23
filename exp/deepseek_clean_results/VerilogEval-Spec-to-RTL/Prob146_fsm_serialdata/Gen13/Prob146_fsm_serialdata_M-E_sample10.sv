module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded states for better timing
    localparam IDLE        = 3'b001;
    localparam RECEIVE     = 3'b010;
    localparam STOP_CHECK  = 3'b100;

    reg [2:0] state, next_state;
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
            case (state)
                IDLE: begin
                    done <= 0;
                    if (!in) begin  // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 0;
                    end
                end

                RECEIVE: begin
                    // Store each bit in its correct position (LSB first)
                    data_reg[bit_count] <= in;
                    
                    if (bit_count == 3'd7) begin
                        state <= STOP_CHECK;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end

                STOP_CHECK: begin
                    if (in) begin  // Valid stop bit
                        out_byte <= data_reg;
                        done <= 1;
                    end
                    // Return to IDLE regardless of stop bit validity
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule