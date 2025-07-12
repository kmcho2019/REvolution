module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [1:0] byte_count;
reg [23:0] message;

assign out_bytes = message;
assign done = (state == 2'b11) && (byte_count == 2'b11);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00;
        byte_count <= 2'b00;
        message <= 24'b0;
    end else begin
        case (state)
            2'b00: begin // Waiting for start of message
                if (in[3]) begin
                    state <= 2'b01;
                    byte_count <= 2'b01;
                    message <= {22'b0, in};
                end
            end
            2'b01: begin // Receiving rest of message
                byte_count <= byte_count + 1'b1;
                message <= {message[15:0], in};
                if (byte_count == 2'b10) begin
                    state <= 2'b11;
                end
            end
            2'b11: begin // Message received, signal done
                state <= 2'b00;
            end
        endcase
    end
end

endmodule