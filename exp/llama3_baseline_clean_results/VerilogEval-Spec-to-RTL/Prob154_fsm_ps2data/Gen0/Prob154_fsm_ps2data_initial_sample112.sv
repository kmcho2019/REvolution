module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [7:0] byte1;
reg [7:0] byte2;
reg [7:0] byte3;
reg [23:0] out_bytes_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        out_bytes_reg <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // transition to BYTE1 state
                    byte1 <= in;
                end
            end
            2'b01: begin // BYTE1 state
                state <= 2'b10; // transition to BYTE2 state
                byte2 <= in;
            end
            2'b10: begin // BYTE2 state
                state <= 2'b00; // transition back to IDLE state
                byte3 <= in;
                out_bytes_reg <= {byte1, byte2, byte3};
                done <= 1'b1;
            end
            default: begin
                state <= 2'b00; // default to IDLE state
            end
        endcase
    end
end

always @(posedge clk) begin
    out_bytes <= out_bytes_reg;
    if (state!= 2'b10) begin
        done <= 1'b0;
    end
end

endmodule