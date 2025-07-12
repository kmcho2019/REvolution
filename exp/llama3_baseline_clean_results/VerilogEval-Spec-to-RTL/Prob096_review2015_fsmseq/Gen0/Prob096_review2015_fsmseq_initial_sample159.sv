module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state; // States: 0 - idle, 1 - got_1, 2 - got_11, 3 - got_110, 4 - found_sequence (not used in this enum)
localparam IDLE = 2'b00;
localparam GOT_1 = 2'b01;
localparam GOT_11 = 2'b10;
localparam GOT_110 = 2'b11;

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case(state)
            IDLE: begin
                if(data == 1) begin
                    state <= GOT_1;
                end else begin
                    state <= IDLE;
                end
            end
            GOT_1: begin
                if(data == 1) begin
                    state <= GOT_11;
                end else if(data == 0) begin
                    state <= GOT_110;
                end else begin
                    state <= IDLE;
                end
            end
            GOT_11: begin
                if(data == 0) begin
                    state <= GOT_110;
                end else begin
                    state <= GOT_1;
                end
            end
            GOT_110: begin
                if(data == 1) begin
                    state <= IDLE; // sequence found
                    start_shifting <= 1;
                end else begin
                    state <= IDLE;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule