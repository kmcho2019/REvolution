module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // 0: Idle, 1: S1, 2: S2, 3: S3, 4: S4
localparam IDLE = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
            S1: begin
                if (data == 1'b1) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (data == 1'b0) begin
                    state <= S3;
                end else begin
                    state <= S1;
                end
            end
            S3: begin
                if (data == 1'b1) begin
                    state <= S4;
                end else begin
                    state <= IDLE;
                end
            end
            S4: begin
                start_shifting <= 1'b1;
            end
        endcase
    end
end

endmodule