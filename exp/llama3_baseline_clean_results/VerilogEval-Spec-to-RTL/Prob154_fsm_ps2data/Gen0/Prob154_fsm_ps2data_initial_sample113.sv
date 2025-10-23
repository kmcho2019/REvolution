module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;

// Initialize the state machine to the IDLE state
initial state = 2'b00;
initial byte1 = 8'b0;
initial byte2 = 8'b0;
initial byte3 = 8'b0;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01;
                end
            end
            2'b01: begin // BYTE1
                byte2 <= in;
                state <= 2'b10;
            end
            2'b10: begin // BYTE2
                byte3 <= in;
                state <= 2'b11;
            end
            2'b11: begin // BYTE3
                out_bytes <= {byte1, byte2, byte3};
                done <= 1'b1;
                state <= 2'b00;
            end
        endcase
    end
end

// Default value of done is 0
always @(*) begin
    if (state == 2'b11) begin
        // Do nothing
    end else begin
        done <= 1'b0;
    end
end

endmodule