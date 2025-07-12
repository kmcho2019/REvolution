module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state;

localparam IDLE = 2'b00;
localparam FOUND1 = 2'b01;
localparam FOUND11 = 2'b10;
localparam FOUND110 = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    state <= FOUND1;
                end else begin
                    state <= IDLE;
                end
            end
            FOUND1: begin
                if (data == 1'b1) begin
                    state <= FOUND11;
                end else if (data == 1'b0) begin
                    state <= FOUND110;
                end else begin
                    state <= IDLE;
                end
            end
            FOUND11: begin
                if (data == 1'b0) begin
                    state <= FOUND110;
                end else begin
                    state <= FOUND1;
                end
            end
            FOUND110: begin
                if (data == 1'b1) begin
                    start_shifting <= 1;
                    state <= FOUND110;
                end else begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule