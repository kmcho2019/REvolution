module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] message;
reg [1:0] byte_counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        message <= 24'b0;
        byte_counter <= 2'b00;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3]) begin
                    state <= 2'b01; // BYTE_1 state
                    message[23:16] <= in;
                    byte_counter <= 2'b01;
                end
            end
            2'b01: begin // BYTE_1 state
                state <= 2'b10; // BYTE_2 state
                message[15:8] <= in;
                byte_counter <= 2'b10;
            end
            2'b10: begin // BYTE_2 state
                message[7:0] <= in;
                byte_counter <= 2'b11;
                done <= 1'b1;
                state <= 2'b00; // IDLE state
            end
            default: state <= 2'b00;
        endcase
    end
end

always @(posedge clk) begin
    if (done) begin
        out_bytes <= message;
    end else begin
        out_bytes <= 24'b0;
    end
end

endmodule