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
        end else begin
            done <= 1'b0;
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        shift_reg <= {in, 16'b0};  // Store first byte
                        state <= FIRST;
                    end
                end

                FIRST: begin
                    shift_reg <= {shift_reg[23:16], in, 8'b0};  // Store second byte
                    state <= SECOND;
                end

                SECOND: begin
                    out_bytes <= {shift_reg[23:8], in};  // Store third byte and output
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule