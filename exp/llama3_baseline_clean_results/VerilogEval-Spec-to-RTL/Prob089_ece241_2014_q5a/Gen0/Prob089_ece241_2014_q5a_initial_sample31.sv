module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state;
parameter IDLE = 2'b00, CONVERT = 2'b01;
reg add_one;
reg [1:0] count;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        add_one <= 1'b0;
        count <= 2'b00;
    end else begin
        case (state)
            IDLE: begin
                state <= CONVERT;
                count <= 2'b01;
                add_one <= x;
                z <= ~x;
            end
            CONVERT: begin
                if (x ^ add_one) begin
                    z <= ~x;
                end else begin
                    z <= x;
                end
                add_one <= 1'b0;
                count <= count + 1'b1;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule