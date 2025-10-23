module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;

    reg [1:0] state;
    reg [23:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_bytes <= 24'bx;
            shift_reg <= 24'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        shift_reg <= {in, 16'b0};  // Store first byte at MSB
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    shift_reg <= {shift_reg[23:16], in, 8'b0};  // Shift in second byte
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    shift_reg <= {shift_reg[23:8], in};         // Shift in third byte
                    out_bytes <= {shift_reg[23:16], shift_reg[15:8], in};  // Final output
                    done <= 1'b1;                               // Assert done
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule