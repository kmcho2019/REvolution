module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;  // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: BYTE3
reg [7:0] byte1, byte2, byte3;  // registers to store received bytes
reg [23:0] out_bytes_reg;  // register to store output bytes

always @(posedge clk) begin
    if (reset) begin
        state <= 0;  // reset to IDLE state
        out_bytes_reg <= 24'b0;  // reset output bytes
        done <= 0;  // reset done signal
    end else begin
        case (state)
            0: begin  // IDLE state
                if (in[3]) begin  // check if in[3] is 1
                    byte1 <= in;  // store the received byte
                    state <= 1;  // transition to BYTE1 state
                end
            end
            1: begin  // BYTE1 state
                byte2 <= in;  // store the received byte
                state <= 2;  // transition to BYTE2 state
            end
            2: begin  // BYTE2 state
                byte3 <= in;  // store the received byte
                state <= 3;  // transition to BYTE3 state
            end
            3: begin  // BYTE3 state
                out_bytes_reg <= {byte1, byte2, byte3};  // assemble output bytes
                done <= 1;  // assert done signal
                state <= 0;  // transition back to IDLE state
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = (state == 3);
endmodule