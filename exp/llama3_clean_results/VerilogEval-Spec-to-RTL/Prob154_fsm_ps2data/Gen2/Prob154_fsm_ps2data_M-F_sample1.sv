module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: BYTE3
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        byte1 <= 8'd0;
        byte2 <= 8'd0;
        byte3 <= 8'd0;
        done <= 1'b0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    byte1 <= in;
                    state <= 1; // BYTE1
                end
            end
            1: begin // BYTE1
                byte2 <= in;
                state <= 2; // BYTE2
            end
            2: begin // BYTE2
                byte3 <= in;
                state <= 3; // BYTE3
            end
            3: begin // BYTE3
                state <= 0; // IDLE
            end
        endcase
    end
end

assign done = (state == 3); // DONE state is after BYTE3
assign out_bytes = {byte1, byte2, byte3};

endmodule