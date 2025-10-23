module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // IDLE (2'b00), BYTE1 (2'b01), BYTE2 (2'b10)
reg [7:0] byte1;
reg [7:0] byte2;
reg [7:0] byte3;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01; // transition to BYTE1 state
                end
            end
            2'b01: begin // BYTE1 state
                byte2 <= in;
                state <= 2'b10; // transition to BYTE2 state
            end
            2'b10: begin // BYTE2 state
                byte3 <= in;
                out_bytes <= {byte1, byte2, byte3};
                done <= 1'b1;
                state <= 2'b00; // transition back to IDLE state
            end
            default: state <= 2'b00; // default to IDLE state
        endcase
        if (state != 2'b10) begin
            done <= 1'b0; // done is only asserted in BYTE2 state
        end
    end
end

endmodule