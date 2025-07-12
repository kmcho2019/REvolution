module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // S_IDLE = 2'b00, S_BYTE_1 = 2'b01, S_BYTE_2 = 2'b10, S_BYTE_3 = 2'b11
reg [23:0] message;
reg [1:0] counter;

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;
        message <= 24'd0;
        counter <= 2'b00;
        done <= 1'b0;
    end
    else begin
        case(state)
            2'b00: begin // S_IDLE
                if(in[3]) begin
                    state <= 2'b01;
                    message[23:16] <= in;
                    counter <= 2'b01;
                end
                else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin // S_BYTE_1
                state <= 2'b10;
                message[15:8] <= in;
                counter <= 2'b10;
            end
            2'b10: begin // S_BYTE_2
                state <= 2'b11;
                message[7:0] <= in;
                counter <= 2'b11;
            end
            2'b11: begin // S_BYTE_3
                state <= 2'b00;
                done <= 1'b1;
            end
            default: begin
                state <= 2'b00;
            end
        endcase
    end
end

always @(posedge clk) begin
    if(~reset) begin
        if(state == 2'b11) begin
            out_bytes <= message;
        end
        else begin
            done <= 1'b0;
        end
    end
    else begin
        out_bytes <= 24'd0;
        done <= 1'b0;
    end
end

endmodule