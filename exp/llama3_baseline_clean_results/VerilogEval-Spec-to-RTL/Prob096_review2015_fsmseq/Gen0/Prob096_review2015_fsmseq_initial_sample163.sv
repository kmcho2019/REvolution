module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state;

localparam IDLE = 3'b000;
localparam FOUND_1 = 3'b001;
localparam FOUND_11 = 3'b010;
localparam FOUND_110 = 3'b011;
localparam FOUND_SEQUENCE = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    state <= FOUND_1;
                end else begin
                    state <= IDLE;
                end
            end
            FOUND_1: begin
                if (data == 1'b1) begin
                    state <= FOUND_11;
                end else if (data == 1'b0) begin
                    state <= IDLE;
                end
            end
            FOUND_11: begin
                if (data == 1'b0) begin
                    state <= FOUND_110;
                end else if (data == 1'b1) begin
                    state <= FOUND_1;
                end
            end
            FOUND_110: begin
                if (data == 1'b1) begin
                    state <= FOUND_SEQUENCE;
                end else if (data == 1'b0) begin
                    state <= IDLE;
                end
            end
            FOUND_SEQUENCE: begin
                start_shifting <= 1'b1;
            end
        endcase
    end
end

endmodule