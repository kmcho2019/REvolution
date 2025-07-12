module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state;

localparam Idle = 3'b000;
localparam Received1 = 3'b001;
localparam Received11 = 3'b010;
localparam Received110 = 3'b011;
localparam FoundSequence = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        start_shifting <= 1'b0;
    end else begin
        case (state)
            Idle: begin
                if (data == 1'b1) begin
                    state <= Received1;
                end else begin
                    state <= Idle;
                end
            end
            Received1: begin
                if (data == 1'b1) begin
                    state <= Received11;
                end else if (data == 1'b0) begin
                    state <= Idle;
                end
            end
            Received11: begin
                if (data == 1'b0) begin
                    state <= Received110;
                end else begin
                    state <= Idle;
                end
            end
            Received110: begin
                if (data == 1'b1) begin
                    state <= FoundSequence;
                    start_shifting <= 1'b1;
                end else begin
                    state <= Idle;
                end
            end
            FoundSequence: begin
                start_shifting <= 1'b1;
            end
        endcase
    end
end

endmodule