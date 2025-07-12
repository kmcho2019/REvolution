module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] state;
    reg next_done;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            done <= 1'b0;
        end else begin
            done <= next_done;
            
            case (state)
                2'b00: begin
                    if (in[3]) begin
                        state <= 2'b01;
                        next_done <= 1'b0;
                    end
                end
                2'b01: begin
                    state <= 2'b10;
                    next_done <= 1'b0;
                end
                2'b10: begin
                    state <= 2'b00;
                    next_done <= 1'b1;
                end
                default: state <= 2'b00;
            endcase
        end
    end

endmodule