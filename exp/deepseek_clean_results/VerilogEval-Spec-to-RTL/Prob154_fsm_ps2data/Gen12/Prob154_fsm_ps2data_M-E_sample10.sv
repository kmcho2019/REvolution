module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Simplified state encoding
    localparam IDLE   = 1'b0;
    localparam ACTIVE = 1'b1;

    reg state;
    reg [1:0] byte_count;
    reg [23:0] shift_reg;
    reg next_done;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 2'b0;
            shift_reg <= 24'bx;
            out_bytes <= 24'bx;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        shift_reg <= {in, 16'b0};  // Initialize shift register
                        byte_count <= 2'b1;
                        state <= ACTIVE;
                    end
                end
                
                ACTIVE: begin
                    shift_reg <= {shift_reg[15:0], in};  // Shift in new byte
                    
                    if (byte_count == 2'b10) begin
                        // Third byte received next cycle
                        out_bytes <= {shift_reg[15:0], in};
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        byte_count <= byte_count + 1'b1;
                    end
                end
            endcase
        end
    end

endmodule