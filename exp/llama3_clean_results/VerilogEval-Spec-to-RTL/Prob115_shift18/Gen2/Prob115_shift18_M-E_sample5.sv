module TopModule(
    input               clk,
    input               load,
    input               ena,
    input       [1:0]   amount,
    input       [63:0]  data,
    output reg  [63:0]  q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena) begin
        reg [63:0] temp_q;
        temp_q = q;
        
        case (amount)
            2'b00: begin // shift left by 1 bit
                temp_q = {q[62:0], 1'b0};
            end
            2'b01: begin // shift left by 8 bits
                temp_q = {q[55:0], 8'b0};
            end
            2'b10: begin // shift right by 1 bit (arithmetic)
                temp_q = {q[63], q[63:1]};
            end
            2'b11: begin // shift right by 8 bits (arithmetic)
                temp_q = {8{q[63]}, q[63:8]};
            end
            default: temp_q = q;
        endcase
        
        q <= temp_q;
    end else begin
        q <= q;
    end
end

endmodule