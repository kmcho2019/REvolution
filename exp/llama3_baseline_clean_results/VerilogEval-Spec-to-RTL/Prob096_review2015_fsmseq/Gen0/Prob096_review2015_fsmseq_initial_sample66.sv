module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state;

localparam idle = 3'b000;
localparam found_1 = 3'b001;
localparam found_11 = 3'b010;
localparam found_110 = 3'b011;
localparam found_1101 = 3'b100;
localparam found_sequence = 3'b101;

always @(posedge clk) begin
    if (reset) begin
        state <= idle;
        start_shifting <= 0;
    end else begin
        case (state)
            idle: begin
                if (data) begin
                    state <= found_1;
                end else begin
                    state <= idle;
                end
            end
            found_1: begin
                if (data) begin
                    state <= found_11;
                end else begin
                    state <= found_1;
                end
            end
            found_11: begin
                if (data) begin
                    state <= found_110;
                end else begin
                    state <= found_1;
                end
            end
            found_110: begin
                if (data == 0) begin
                    state <= found_1101;
                end else begin
                    state <= found_11;
                end
            end
            found_1101: begin
                if (data == 1) begin
                    state <= found_sequence;
                    start_shifting <= 1;
                end else begin
                    state <= found_1;
                end
            end
            found_sequence: begin
                state <= found_sequence;
            end
        endcase
    end
end

endmodule