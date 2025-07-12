module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // 3-bit state register

// Define states
parameter IDLE = 3'b000;
parameter FOUND1 = 3'b001;
parameter FOUND11 = 3'b010;
parameter FOUND110 = 3'b011;
parameter FOUND1101 = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1) begin
                    state <= FOUND1;
                end else begin
                    state <= IDLE;
                end
            end
            FOUND1: begin
                if (data == 1) begin
                    state <= FOUND11;
                end else if (data == 0) begin
                    state <= FOUND110;
                end else begin
                    state <= FOUND1;
                end
            end
            FOUND11: begin
                if (data == 0) begin
                    state <= FOUND110;
                end else begin
                    state <= FOUND1;
                end
            end
            FOUND110: begin
                if (data == 1) begin
                    state <= FOUND1101;
                end else begin
                    state <= IDLE;
                end
            end
            FOUND1101: begin
                start_shifting <= 1;
                state <= FOUND1101;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule