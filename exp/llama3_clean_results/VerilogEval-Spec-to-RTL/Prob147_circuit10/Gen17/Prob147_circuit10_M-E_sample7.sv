module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg [1:0] state
);

always @(posedge clk) begin
    case(state)
        2'b00: begin
            if (!a) begin
                state <= {1'b0, b};
            end else if (a && b) begin
                state <= 2'b10;
            end else begin
                state <= 2'b00;
            end
        end
        2'b01: begin
            if (!a) begin
                state <= 2'b00;
            end else if (a && b) begin
                state <= 2'b11;
            end else begin
                state <= 2'b01;
            end
        end
        2'b10: begin
            if (!a) begin
                state <= 2'b10;
            end else if (a && b) begin
                state <= 2'b00;
            end else begin
                state <= 2'b10;
            end
        end
        2'b11: begin
            if (!a) begin
                state <= 2'b11;
            end else if (a && b) begin
                state <= 2'b01;
            end else begin
                state <= 2'b11;
            end
        end
        default: state <= 2'b00;
    endcase
end

assign q = a ^ b;

initial begin
    state = 2'b00;
end

endmodule