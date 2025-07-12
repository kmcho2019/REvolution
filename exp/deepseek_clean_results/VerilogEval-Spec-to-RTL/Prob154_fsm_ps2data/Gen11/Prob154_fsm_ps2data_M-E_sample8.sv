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
    assign done = (state && byte_counter == 2'd2);
    assign out_bytes = done ? shift_reg : 24'bx;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;
            byte_counter <= 2'b0;
            shift_reg <= 24'bx;
        end else begin
            case (state)
                1'b0: begin // IDLE
                    if (in[3]) begin
                        state <= 1'b1;
                        byte_counter <= 2'b0;
                        shift_reg <= {16'b0, in};
                    end
                end
                1'b1: begin // COLLECT
                    shift_reg <= {shift_reg[15:0], in};
                    byte_counter <= byte_counter + 1'b1;
                    
                    if (byte_counter == 2'd2) begin
                        state <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule