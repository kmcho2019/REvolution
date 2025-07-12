module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output reg [23:0] out_bytes,
    output reg       done
);

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        done <= 0;
        out_bytes <= 24'b0;
    end else begin
        case (state)
            2'b00: begin // idle state
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01;
                end
            end
            2'b01: begin // byte1 state
                byte2 <= in;
                state <= 2'b10;
            end
            2'b10: begin // byte2 state
                byte3 <= in;
                state <= 2'b11;
            end
            2'b11: begin // done state
                out_bytes <= {byte1, byte2, byte3};
                done <= 1;
                state <= 2'b00;
            end
        endcase
    end
end

always @ (*) begin
    if (state == 2'b11) begin
        done = 1'b1;
    end else begin
        done = 1'b0;
    end
end

endmodule