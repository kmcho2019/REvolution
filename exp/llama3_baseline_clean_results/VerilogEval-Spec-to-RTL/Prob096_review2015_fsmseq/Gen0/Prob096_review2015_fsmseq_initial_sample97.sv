module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state;

localparam IDLE = 2'b00;
localparam SEQ_1 = 2'b01;
localparam SEQ_11 = 2'b10;
localparam SEQ_110 = 2'b11;
localparam FINAL = 2'b01; // reused as final state, start_shifting is set

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= SEQ_1;
                end
            end
            SEQ_1: begin
                if (data) begin
                    state <= SEQ_11;
                end else begin
                    state <= SEQ_1;
                end
            end
            SEQ_11: begin
                if (!data) begin
                    state <= SEQ_110;
                end else begin
                    state <= SEQ_1;
                end
            end
            SEQ_110: begin
                if (data) begin
                    state <= FINAL;
                end else begin
                    state <= IDLE;
                end
            end
            default: begin // FINAL state
                start_shifting <= 1;
            end
        endcase
    end
end

always @(*) begin
    if (state == FINAL) begin
        start_shifting = 1;
    end else if (reset) begin
        start_shifting = 0;
    end
end

endmodule