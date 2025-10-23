module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] message;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        message <= 24'd0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Waiting for the start of the message
                if (in[3] == 1'b1) begin
                    message[7:0] <= in;
                    state <= 2'b01;
                end
            end
            2'b01: begin // Received the first byte, waiting for the second byte
                message[15:8] <= in;
                state <= 2'b10;
            end
            2'b10: begin // Received the second byte, waiting for the third byte
                message[23:16] <= in;
                done <= 1'b1;
                state <= 2'b00;
            end
            default: state <= 2'b00;
        endcase
    end
end

assign out_bytes = (done) ? message : 24'd0;

endmodule