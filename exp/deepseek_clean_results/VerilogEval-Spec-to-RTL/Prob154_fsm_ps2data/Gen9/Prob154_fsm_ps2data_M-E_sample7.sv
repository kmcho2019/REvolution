module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Gray-coded state encoding for low-power transitions
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] BYTE1 = 2'b01;
    localparam [1:0] BYTE2 = 2'b11;
    localparam [1:0] DONE  = 2'b10;

    reg [1:0] state;
    reg [23:0] shift_reg;
    reg shift_enable;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            shift_reg <= 24'bx;
            shift_enable <= 1'b0;
            out_bytes <= 24'bx;
        end else begin
            // Default assignments
            done <= 1'b0;
            shift_enable <= 1'b0;

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        shift_reg <= {in, 16'bx}; // Load first byte
                        shift_enable <= 1'b1;
                        state <= BYTE1;
                    end
                end

                BYTE1: begin
                    shift_reg <= {shift_reg[15:0], in}; // Shift in second byte
                    shift_enable <= 1'b1;
                    state <= BYTE2;
                end

                BYTE2: begin
                    shift_reg <= {shift_reg[15:0], in}; // Shift in third byte
                    out_bytes <= {shift_reg[23:16], shift_reg[15:8], in}; // Capture all 3 bytes
                    done <= 1'b1;
                    state <= DONE;
                end

                DONE: begin
                    state <= IDLE;
                    if (in[3]) begin // Handle back-to-back messages
                        shift_reg <= {in, 16'bx};
                        shift_enable <= 1'b1;
                        state <= BYTE1;
                    end
                end
            endcase
        end
    end

endmodule