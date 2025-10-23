module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state; // 2-bit state register
reg [1:0] byte_count; // 2-bit byte counter

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        byte_count <= 2'b00;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3]) begin
                    state <= 2'b01; // transition to BYTE1 state
                    byte_count <= 2'b01;
                end
            end
            2'b01: begin // BYTE1 state
                state <= 2'b10; // transition to BYTE2 state
                byte_count <= 2'b10;
            end
            2'b10: begin // BYTE2 state
                state <= 2'b11; // transition to DONE state
                byte_count <= 2'b11;
            end
            2'b11: begin // DONE state
                state <= 2'b00; // reset to IDLE state
                byte_count <= 2'b00;
            end
        endcase
    end
end

assign done = (state == 2'b11); // signal 'done' when in DONE state

endmodule