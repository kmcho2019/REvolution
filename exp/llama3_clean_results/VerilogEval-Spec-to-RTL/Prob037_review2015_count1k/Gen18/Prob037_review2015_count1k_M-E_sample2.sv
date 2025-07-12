module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] count;
reg [1:0] state;

always @(posedge clk) begin
    case (state)
        2'b00: begin // idle state
            if (~reset) begin
                state <= 2'b01;
                count <= 10'd0;
            end else begin
                state <= 2'b00;
                count <= 10'd0;
            end
        end
        2'b01: begin // counting state
            if (count == 10'd999) begin
                state <= 2'b01;
                count <= 10'd0;
            end else begin
                state <= 2'b01;
                count <= count + 10'd1;
            end
            if (reset) begin
                state <= 2'b00;
                count <= 10'd0;
            end
        end
        default: begin
            state <= 2'b00;
            count <= 10'd0;
        end
    endcase
end

assign q = count;

endmodule