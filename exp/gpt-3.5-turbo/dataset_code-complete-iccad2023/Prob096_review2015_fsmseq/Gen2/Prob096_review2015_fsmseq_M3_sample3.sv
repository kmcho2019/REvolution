module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [2:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b0;
        start_shifting <= 0;
    end
    else begin
        case (state)
            3'b000: begin
                if (data) state <= 3'b001;
                else state <= 3'b000;
            end
            3'b001: begin
                if (data) state <= 3'b010;
                else state <= 3'b000;
            end
            3'b010: begin
                if (~data) state <= 3'b000;
                else if (data) state <= 3'b011;
            end
            3'b011: begin
                if (data) begin
                    state <= 3'b011;
                    start_shifting <= 1;
                end
                else begin
                    state <= 3'b000;
                    start_shifting <= 0;
                end
            end
            default: state <= 3'b0;
        endcase
    end
end

endmodule