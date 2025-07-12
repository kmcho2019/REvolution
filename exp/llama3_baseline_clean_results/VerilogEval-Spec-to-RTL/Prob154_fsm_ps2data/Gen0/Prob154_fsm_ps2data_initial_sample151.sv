module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
reg [7:0] byte1;
reg [7:0] byte2;
reg [7:0] byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
        done <= 1'b0;
        out_bytes <= 24'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01; // BYTE1 state
                end
            end
            2'b01: begin // BYTE1 state
                byte2 <= in;
                state <= 2'b10; // BYTE2 state
            end
            2'b10: begin // BYTE2 state
                byte3 <= in;
                state <= 2'b11; // DONE state
            end
            2'b11: begin // DONE state
                out_bytes <= {byte1, byte2, byte3};
                done <= 1'b1;
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01; // BYTE1 state
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule