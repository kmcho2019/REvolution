module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] message;
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Idle state
        message <= 24'd0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01; // Byte1 state
                end
            end
            2'b01: begin // Byte1 state
                byte2 <= in;
                state <= 2'b10; // Byte2 state
            end
            2'b10: begin // Byte2 state
                byte3 <= in;
                state <= 2'b11; // Done state
            end
            2'b11: begin // Done state
                state <= 2'b00; // Idle state
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b11: begin // Done state
            message = {byte1, byte2, byte3};
            done = 1'b1;
        end
        default: begin
            done = 1'b0;
        end
    endcase
end

assign out_bytes = message;

endmodule