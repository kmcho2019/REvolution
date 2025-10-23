module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Binary state encoding with clear names
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] BYTE1 = 2'b01;
    localparam [1:0] BYTE2 = 2'b10;

    reg [1:0] state;
    reg [23:0] next_out_bytes;
    reg next_done;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_bytes <= 24'bx;
        end else begin
            // Register the outputs
            out_bytes <= next_out_bytes;
            done <= next_done;
            
            // Default assignments
            next_done <= 1'b0;
            next_out_bytes <= out_bytes; // Hold previous value unless updated
            
            case (state)
                IDLE: begin
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
                    next_done <= 1'b1;        // Will be registered next cycle
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule