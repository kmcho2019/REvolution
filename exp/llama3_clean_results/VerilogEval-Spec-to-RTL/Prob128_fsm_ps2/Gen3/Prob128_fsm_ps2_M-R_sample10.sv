module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state; // 2-bit state register
reg [1:0] byte_count; // 2-bit byte counter

localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte_count <= 2'b00;
    end else begin
        case (state)
            IDLE: begin
                if (in[3]) begin
                    state <= BYTE1;
                    byte_count <= 2'b01;
                end
            end
            BYTE1: begin
                state <= BYTE2;
                byte_count <= 2'b10;
            end
            BYTE2: begin
                state <= IDLE;
                byte_count <= 2'b00;
            end
        endcase
    end
end

assign done = (state == BYTE2);

endmodule