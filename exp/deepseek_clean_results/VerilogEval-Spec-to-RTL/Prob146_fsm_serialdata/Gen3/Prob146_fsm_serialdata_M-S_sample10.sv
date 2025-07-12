module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam IDLE  = 1'b0;
    localparam ACTIVE = 1'b1;

    reg state;
    reg [3:0] bit_count; // Counts 0-8 (start + 8 bits)
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // Default to 0, pulse when stop bit found
            
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin // Start bit detected
                        state <= ACTIVE;
                        bit_count <= 4'b0;
                    end
                end
                
                ACTIVE: begin
                    if (bit_count < 4'd8) begin
                        shift_reg <= {shift_reg[6:0], in}; // Left shift (LSB first)
                    end
                    
                    if (bit_count == 4'd8) begin // Stop bit check
                        if (in == 1'b1) begin
                            out_byte <= shift_reg;
                            done <= 1'b1;
                            state <= IDLE;
                        end
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
            endcase
        end
    end

endmodule