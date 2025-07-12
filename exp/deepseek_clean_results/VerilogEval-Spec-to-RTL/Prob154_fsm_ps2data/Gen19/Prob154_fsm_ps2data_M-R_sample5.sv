module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // One-hot state encoding
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    reg [2:0] state;
    reg [23:0] byte_buffer;
    reg done_reg;

    // Combinational output assignments
    assign out_bytes = done_reg ? byte_buffer : 24'bx;
    assign done = done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 1'b0;
            byte_buffer <= 24'b0;
        end else begin
            done_reg <= 1'b0; // Default assignment
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte_buffer[23:16] <= in;
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    byte_buffer[15:8] <= in;
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    byte_buffer[7:0] <= in;
                    done_reg <= 1'b1;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule