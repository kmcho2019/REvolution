module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Binary state encoding (2 bits)
    localparam IDLE  = 2'b00;
    localparam BYTE2 = 2'b01;
    localparam BYTE3 = 2'b10;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            // out_bytes don't-care during reset
        end else begin
            // Default assignments
            done <= 1'b0;

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        out_bytes[23:16] <= in; // Store first byte
                        state <= BYTE2;
                    end
                end
                
                BYTE2: begin
                    out_bytes[15:8] <= in; // Store second byte
                    state <= BYTE3;
                end
                
                BYTE3: begin
                    out_bytes[7:0] <= in; // Store third byte
                    done <= 1'b1;        // Assert done
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule