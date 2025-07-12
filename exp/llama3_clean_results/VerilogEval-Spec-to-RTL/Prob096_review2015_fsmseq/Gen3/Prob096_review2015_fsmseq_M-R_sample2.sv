module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state;
localparam IDLE = 3'b000;
localparam FOUND1 = 3'b001;
localparam FOUND11 = 3'b010;
localparam FOUND110 = 3'b011;
reg found_1101;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        found_1101 <= 0;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= FOUND1;
                end
            end
            FOUND1: begin
                if (data) begin
                    state <= FOUND11;
                end else begin
                    state <= IDLE;
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
                    found_1101 <= 1;
                end else begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

assign start_shifting = found_1101;

endmodule