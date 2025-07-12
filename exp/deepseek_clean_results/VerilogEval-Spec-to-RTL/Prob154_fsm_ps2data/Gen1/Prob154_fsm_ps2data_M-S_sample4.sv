module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;
    reg [23:0] byte_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            out_bytes <= 24'b0;
            done <= 0;
        end else begin
            done <= 0;
            
            case (state)
                2'b00: begin  // Waiting for start byte
                    if (in[3]) begin
                        byte_shift <= {16'b0, in};
                        state <= 2'b01;
                    end
                end
                
                2'b01: begin  // Second byte
                    byte_shift <= {byte_shift[15:0], in};
                    state <= 2'b10;
                end
                
                2'b10: begin  // Third byte
                    out_bytes <= {byte_shift[15:0], in};
                    done <= 1;
                    state <= 2'b00;
                end
            endcase
        end
    end

endmodule