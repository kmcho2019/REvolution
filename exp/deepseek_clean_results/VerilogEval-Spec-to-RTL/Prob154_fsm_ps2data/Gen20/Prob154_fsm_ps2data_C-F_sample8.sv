module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // States with binary encoding
    reg [1:0] state;
    localparam IDLE      = 2'b00;
    localparam FIRST_BYTE  = 2'b01;
    localparam SECOND_BYTE = 2'b10;

    // Separate byte registers for power optimization
    reg [7:0] byte1, byte2, byte3;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            out_bytes <= 24'bx;
            byte1 <= 8'bx;
            byte2 <= 8'bx;
            byte3 <= 8'bx;
        end else begin
            done <= 0;  // Default assignment
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        state <= FIRST_BYTE;
                    end
                end
                
                FIRST_BYTE: begin
                    byte2 <= in;
                    state <= SECOND_BYTE;
                end
                
                SECOND_BYTE: begin
                    byte3 <= in;
                    out_bytes <= {byte1, byte2, in};  // Concatenate only when done
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule