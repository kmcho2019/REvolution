module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // State definitions
    localparam WAIT = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    
    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            // State transitions
            case (state)
                WAIT: begin
                    if (in[3]) begin
                        state <= BYTE1;
                    end
                end
                BYTE1: begin
                    state <= BYTE2;
                end
                BYTE2: begin
                    done <= 1'b1;
                    state <= WAIT;
                end
                default: state <= WAIT;
            endcase
        end
    end

endmodule