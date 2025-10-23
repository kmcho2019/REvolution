module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Binary encoded states
    reg [1:0] state;
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;

    // Shift register for byte collection
    reg [23:0] byte_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            byte_shift <= 24'bx;
        end else begin
            done <= 1'b0;  // Default assignment
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte_shift <= {in, 16'b0};
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    byte_shift <= {byte_shift[23:16], in, 8'b0};
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    byte_shift <= {byte_shift[23:8], in};
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

    // Output assignment (combinational)
    always @(*) begin
        out_bytes = done ? byte_shift : 24'bx;
    end

endmodule