module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Binary state encoding
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] BYTE1 = 2'b01;
    localparam [1:0] BYTE2 = 2'b10;

    reg [1:0] state;
    reg [23:0] next_out_bytes;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_bytes <= 24'bx; // Don't-care during reset
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        next_out_bytes[23:16] <= in; // Store first byte
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    next_out_bytes[15:8] <= in; // Store second byte
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    next_out_bytes[7:0] <= in; // Store third byte
                    out_bytes <= next_out_bytes; // Update output only when done
                    done <= 1'b1;               // Assert done
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule