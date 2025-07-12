module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // Binary encoded states
    reg [1:0] state;
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;

    // Shift register for byte collection
    reg [23:0] byte_shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_shift_reg <= 24'bx;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte_shift_reg[23:16] <= in;
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    byte_shift_reg[15:8] <= in;
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    byte_shift_reg[7:0] <= in;
                    state <= IDLE;
                end
            endcase
        end
    end

    // Combinatorial outputs
    assign out_bytes = (state == BYTE2) ? {byte_shift_reg[23:8], in} : 24'bx;
    assign done = (state == BYTE2);

endmodule