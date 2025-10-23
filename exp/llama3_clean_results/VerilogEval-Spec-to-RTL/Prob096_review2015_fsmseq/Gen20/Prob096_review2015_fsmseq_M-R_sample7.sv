module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state;

initial state = 3'b000;

always @(posedge clk) begin
    if(reset) begin
        state <= 3'b000;
        start_shifting <= 0;
    end else begin
        case(state)
            3'b000: begin
                if(data) begin
                    state <= 3'b001;
                end else begin
                    state <= 3'b000;
                end
            end
            3'b001: begin
                if(data) begin
                    state <= 3'b010;
                end else begin
                    state <= 3'b000;
                end
            end
            3'b010: begin
                if(!data) begin
                    state <= 3'b011;
                end else begin
                    state <= 3'b010;
                end
            end
            3'b011: begin
                if(data) begin
                    state <= 3'b100;
                    start_shifting <= 1;
                end else begin
                    state <= 3'b000;
                end
            end
            3'b100: begin
                state <= 3'b100;
            end
        endcase
    end
end

endmodule