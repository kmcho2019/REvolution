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
            done <= 1'b0; // Default assignment
            
            case (state)
                2'b00: begin
                    if (in[3]) begin
                        state <= 2'b01; // Start new message
                    end
                end
                2'b01: begin
                    state <= 2'b10; // Second byte
                end
                2'b10: begin
                    state <= 2'b00; // Third byte - reset
                    done <= 1'b1;  // Assert done
                end
                default: state <= 2'b00;
            endcase
        end
    end

endmodule