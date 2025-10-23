module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state;
localparam IDLE = 2'b00;
localparam FOUND1 = 2'b01;
localparam FOUND11 = 2'b10;
localparam FOUND110 = 3'b100;
localparam FOUND1101 = 3'b101;
localparam SHIFT = 3'b110;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= FOUND1;
                end else begin
                    state <= IDLE;
                end
            end
            FOUND1: begin
                if (data) begin
                    state <= FOUND11;
                end else begin
                    state <= FOUND1;
                end
            end
            FOUND11: begin
                if (!data) begin
                    state <= FOUND110;
                end else begin
                    state <= FOUND1;
                end
            end
            FOUND110: begin
                if (data) begin
                    state <= FOUND1101;
                end else begin
                    state <= IDLE;
                end
            end
            FOUND1101: begin
                start_shifting <= 1;
                state <= SHIFT;
            end
            SHIFT: begin
                start_shifting <= 1;
            end
        endcase
    end
end

endmodule