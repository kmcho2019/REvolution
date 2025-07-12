module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [1:0] next_state;
reg [7:0] byte1;
reg [7:0] byte2;
reg [7:0] byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3]) begin
                    byte1 <= in;
                    state <= 2'b01; // BYTE1
                end
            end
            2'b01: begin // BYTE1
                byte2 <= in;
                state <= 2'b10; // BYTE2
            end
            2'b10: begin // BYTE2
                byte3 <= in;
                state <= 2'b11; // DONE
                done <= 1'b1;
            end
            2'b11: begin // DONE
                done <= 1'b0;
                state <= 2'b00; // IDLE
            end
        endcase
    end
end

assign out_bytes = {byte1, byte2, byte3};

endmodule