module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

enum logic [1:0] {IDLE, BYTE1, BYTE2, BYTE3} state;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
    end
    else begin
        case(state)
            IDLE: begin
                if(in[3]) state <= BYTE1;
            end
            BYTE1: state <= BYTE2;
            BYTE2: state <= BYTE3;
            BYTE3: state <= IDLE;
        endcase
    end
end

assign done = (state == BYTE3);

endmodule