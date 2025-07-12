module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    reg [23:0] shift_reg;
    reg [1:0] byte_counter;
    reg state; // 0: IDLE, 1: COLLECT

    // Combinatorial done signal
    assign done = (byte_counter == 2'b10) && (state == 1'b1);
    assign out_bytes = done ? shift_reg : 24'bx;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'bx;
            byte_counter <= 2'b00;
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: begin // IDLE
                    if (in[3]) begin
                        shift_reg <= {in, 16'b0}; // Shift in first byte
                        byte_counter <= 2'b01;
                        state <= 1'b1;
                    end
                end
                1'b1: begin // COLLECT
                    shift_reg <= {shift_reg[15:0], in}; // Shift in next byte
                    if (byte_counter == 2'b10) begin
                        byte_counter <= 2'b00;
                        state <= 1'b0;
                    end else begin
                        byte_counter <= byte_counter + 1'b1;
                    end
                end
            endcase
        end
    end

endmodule