module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

parameter IDLE = 2'b00;
parameter ACCUMULATE = 2'b01;

reg [7:0] result;
reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        result <= 8'b0;
        z <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (x == 1'b1) begin
                    state <= ACCUMULATE;
                    result <= result + 1;
                end
            end
            ACCUMULATE: begin
                if (x == 1'b0) begin
                    state <= IDLE;
                end
                else begin
                    result <= result + 1;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

assign z = result;

endmodule