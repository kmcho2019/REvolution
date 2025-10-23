module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // 0: idle, 1: byte1, 2: byte2, 3: done
reg [23:0] out_bytes_reg;
reg [7:0] byte1, byte2;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // idle state
        out_bytes_reg <= 24'd0;
        byte1 <= 8'd0;
        byte2 <= 8'd0;
        done <= 1'b0;
    end else begin
        case (state)
            0: begin // idle state
                if (in[3] == 1'b1) begin
                    state <= 1; // move to byte1 state
                    byte1 <= in;
                end
            end
            1: begin // byte1 state
                state <= 2; // move to byte2 state
                byte2 <= in;
            end
            2: begin // byte2 state
                state <= 3; // move to done state
                out_bytes_reg <= {byte1, byte2, in};
            end
            3: begin // done state
                done <= 1'b1;
                state <= 0; // move back to idle state
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = (state == 3);

endmodule