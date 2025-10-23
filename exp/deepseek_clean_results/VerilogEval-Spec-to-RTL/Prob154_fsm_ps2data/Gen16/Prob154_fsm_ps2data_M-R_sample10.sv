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
    reg [7:0] byte1, byte2, byte3;

    // Combinational outputs
    assign out_bytes = {byte1, byte2, byte3};
    assign done = (state == BYTE2);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'bx;
            byte2 <= 8'bx;
            byte3 <= 8'bx;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    byte2 <= in;
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    byte3 <= in;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule