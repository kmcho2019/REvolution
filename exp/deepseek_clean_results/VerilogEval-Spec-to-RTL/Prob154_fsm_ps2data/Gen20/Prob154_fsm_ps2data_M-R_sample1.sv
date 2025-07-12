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
    reg [23:0] byte_reg;

    // Combinational done signal
    assign done = (state == BYTE2);
    assign out_bytes = done ? byte_reg : 24'bx;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_reg <= 24'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte_reg[23:16] <= in;
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    byte_reg[15:8] <= in;
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    byte_reg[7:0] <= in;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule