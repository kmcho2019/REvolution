module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // Idle (2'b00), Byte1 (2'b01), Byte2 (2'b10)
reg [7:0] byte1, byte2, byte3;
reg [23:0] message;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00; // Reset to Idle state
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end else begin
        case(state)
            2'b00: begin // Idle
                if(in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01;
                end
            end
            2'b01: begin // Byte1
                byte2 <= in;
                state <= 2'b10;
            end
            2'b10: begin // Byte2
                byte3 <= in;
                state <= 2'b00; // Return to Idle after receiving the third byte
            end
        endcase
    end
end

assign message = {byte1, byte2, byte3};
assign out_bytes = (state == 2'b10) ? message : 24'b0;
assign done = (state == 2'b10);

endmodule