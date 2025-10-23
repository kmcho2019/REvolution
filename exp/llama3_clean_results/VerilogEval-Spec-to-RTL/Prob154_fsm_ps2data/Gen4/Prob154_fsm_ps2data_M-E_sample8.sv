module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
reg [1:0] byte_count;
reg [23:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'd0;
        byte_count <= 2'd0;
        shift_reg <= 24'd0;
        done <= 1'b0;
    end else begin
        case (state)
            2'd0: begin // IDLE state
                if (in[3] == 1'b1) begin
                    shift_reg <= {20'd0, in}; // store the first byte
                    state <= 2'd1;
                    byte_count <= 2'd1;
                end
            end
            2'd1: begin // RECEIVING state
                shift_reg <= {shift_reg[15:0], in}; // shift in the new byte
                byte_count <= byte_count + 1'd1;
                if (byte_count == 2'd3) begin
                    state <= 2'd0;
                    done <= 1'b1;
                end
            end
        endcase
    end
end

assign out_bytes = (done) ? shift_reg : 24'bx;

always @(posedge clk) begin
    if (!reset && state == 2'd0 && byte_count == 2'd0) begin
        done <= 1'b0;
    end
end

endmodule