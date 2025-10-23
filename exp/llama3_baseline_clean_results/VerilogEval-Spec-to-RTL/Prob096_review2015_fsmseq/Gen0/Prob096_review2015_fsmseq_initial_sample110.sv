module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state;

localparam IDLE = 2'b00;
localparam FIRST_ONE = 2'b01;
localparam FIRST_ZERO = 2'b10;
localparam SEQUENCE_FOUND = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= FIRST_ONE;
                end else begin
                    state <= IDLE;
                end
            end
            FIRST_ONE: begin
                if (data) begin
                    state <= FIRST_ONE;
                end else begin
                    state <= FIRST_ZERO;
                end
            end
            FIRST_ZERO: begin
                if (data) begin
                    state <= SEQUENCE_FOUND;
                end else begin
                    state <= IDLE;
                end
            end
            SEQUENCE_FOUND: begin
                state <= SEQUENCE_FOUND;
            end
        endcase
        if (state == SEQUENCE_FOUND) begin
            start_shifting <= 1;
        end else begin
            start_shifting <= 0;
        end
    end
end

endmodule