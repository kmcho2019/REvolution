module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Binary state encoding
    localparam IDLE     = 2'b00;
    localparam FIRST    = 2'b01;
    localparam SECOND   = 2'b10;

    reg [1:0] state;
    reg [23:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_bytes <= 24'bx;
            shift_reg <= 24'b0;
        end else begin
            done <= 1'b0;  // Default assignment

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        shift_reg <= {shift_reg[15:0], in};  // Shift in first byte
                        state <= FIRST;
                    end
                end

                FIRST: begin
                    shift_reg <= {shift_reg[15:0], in};      // Shift in second byte
                    state <= SECOND;
                end

                SECOND: begin
                    shift_reg <= {shift_reg[15:0], in};      // Shift in third byte
                    out_bytes <= {shift_reg[15:0], in};       // Update output
                    done <= 1'b1;                            // Assert done
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule