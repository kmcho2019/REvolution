module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            case (state)
                2'b00: begin
                    if (in[3]) begin
                        state <= 2'b01;
                    end
                end
                2'b01: begin
                    state <= 2'b10;
                end
                2'b10: begin
                    state <= 2'b00;
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule