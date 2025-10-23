module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] curr_state;
reg [1:0] byte_count;
reg [23:0] out_bytes_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        curr_state <= 2'b00;
        byte_count <= 2'b00;
        out_bytes_reg <= 24'd0;
    end else begin
        case (curr_state)
            2'b00: begin
                if (in[3]) begin
                    curr_state <= 2'b01;
                    out_bytes_reg[7:0] <= in;
                    byte_count <= 2'b01;
                end else begin
                    curr_state <= 2'b00;
                end
            end
            2'b01: begin
                if (byte_count == 2'b01) begin
                    out_bytes_reg[15:8] <= in;
                    byte_count <= 2'b10;
                end else if (byte_count == 2'b10) begin
                    out_bytes_reg[23:16] <= in;
                    curr_state <= 2'b10;
                end else begin
                    curr_state <= 2'b01;
                end
            end
            2'b10: begin
                curr_state <= 2'b00;
            end
            default: curr_state <= 2'b00;
        endcase
    end
end

assign done = (curr_state == 2'b10);
assign out_bytes = (curr_state == 2'b10) ? out_bytes_reg : 24'd0;

endmodule