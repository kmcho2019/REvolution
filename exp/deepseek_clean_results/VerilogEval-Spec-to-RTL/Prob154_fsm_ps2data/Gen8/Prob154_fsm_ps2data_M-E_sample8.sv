module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam [2:0] IDLE  = 3'b001;
    localparam [2:0] BYTE1 = 3'b010;
    localparam [2:0] BYTE2 = 3'b100;

    reg [2:0] state;
    reg [23:0] shift_reg;
    reg next_done;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 24'bx;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            shift_reg <= shift_reg;

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        shift_reg <= {in, 16'b0}; // Initialize shift register
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    shift_reg <= {shift_reg[23:16], in, 8'b0}; // Shift in second byte
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    shift_reg <= {shift_reg[23:8], in}; // Shift in third byte
                    done <= 1'b1;                       // Assert done
                    state <= IDLE;
                end
            endcase
        end
    end

    // Output is valid only when done is asserted
    always @(*) begin
        out_bytes = done ? shift_reg : 24'bx;
    end

endmodule