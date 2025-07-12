module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] message;
reg [7:0] byte_1, byte_2, byte_3;
reg done_reg;

initial begin
    state = 2'b00; // IDLE
    done_reg = 1'b0;
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state = 2'b00;
        done_reg = 1'b0;
        message = 24'b0;
    end
    else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3] == 1'b1) begin
                    state = 2'b01; // BYTE_1
                    byte_1 = in;
                end
                else begin
                    state = 2'b00;
                end
                done_reg = 1'b0;
            end
            2'b01: begin // BYTE_1
                state = 2'b10; // BYTE_2
                byte_2 = in;
            end
            2'b10: begin // BYTE_2
                state = 2'b11; // BYTE_3
                byte_3 = in;
            end
            2'b11: begin // BYTE_3
                state = 2'b00; // IDLE
                message = {byte_1, byte_2, byte_3};
                done_reg = 1'b1;
            end
            default: state = 2'b00;
        endcase
    end
end

assign out_bytes = message;
assign done = done_reg;

endmodule