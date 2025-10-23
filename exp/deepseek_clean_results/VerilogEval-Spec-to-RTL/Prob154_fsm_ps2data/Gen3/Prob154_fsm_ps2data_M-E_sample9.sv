module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    reg [1:0] state;
    reg [1:0] byte_count;
    
    // State encoding
    localparam IDLE      = 2'b00;
    localparam COLLECTING = 2'b01;
    localparam DONE      = 2'b10;

    // Combinational done signal
    assign done = (state == DONE);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 2'b00;
            out_bytes <= 24'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        // Start new message
                        out_bytes <= {in, 16'b0};
                        byte_count <= 2'b01;
                        state <= COLLECTING;
                    end
                end
                
                COLLECTING: begin
                    // Shift in new byte
                    out_bytes <= {out_bytes[15:0], in};
                    
                    if (byte_count == 2'b10) begin
                        // Collected all 3 bytes
                        state <= DONE;
                    end else begin
                        byte_count <= byte_count + 1;
                    end
                end
                
                DONE: begin
                    // Return to IDLE after one cycle
                    state <= IDLE;
                    byte_count <= 2'b00;
                    
                    // Check if next byte starts new message
                    if (in[3]) begin
                        out_bytes <= {in, 16'b0};
                        byte_count <= 2'b01;
                        state <= COLLECTING;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule